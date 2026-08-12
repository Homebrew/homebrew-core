require "net/http"

class Msgvault < Formula
  desc "Archive a lifetime of email and chat with offline search and analytics"
  homepage "https://github.com/kenn-io/msgvault"
  url "https://github.com/kenn-io/msgvault/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "2aa8dc6c3228acb8d94920714fe32617dfd85dc6d02d3aa9c0d511df9e330401"
  license "MIT"
  revision 1
  head "https://github.com/kenn-io/msgvault.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2b7bc4fa9802ce4afaa14a7741ed3b8963cf2dd4ddb219bfec9bb98966bcaca4"
    sha256 cellar: :any, arm64_sequoia: "18d799c24f15051bf52780f891dd61608dbb46ca5ddfe6618f96d4e0096938da"
    sha256 cellar: :any, arm64_sonoma:  "caef7d82dbac2caddb1a7fd47529d9334096dc1801ad1d70c68fc24e04397a51"
    sha256 cellar: :any, sonoma:        "650b911af7f0f0153b5817cb50fca1f2fc405430c8f5402a7a3377367e29a242"
    sha256 cellar: :any, arm64_linux:   "f7e7d23c99a68bfc73e07b913a3489ce69d89ec35020b72389334ce662d5468d"
    sha256 cellar: :any, x86_64_linux:  "e612f94d976567fb03d614baf1cb5a80de80f9576f1af3d7fdf46e0e7ad0425e"
  end

  depends_on "bun" => :build
  depends_on "go" => :build
  depends_on "duckdb"

  uses_from_macos "sqlite" => :build

  def install
    cd "web" do
      system "bun", "install", "--frozen-lockfile"
      system "bun", "run", "generate"
      system "bun", "run", "build"
    end

    dist = buildpath/"internal/web/dist"
    dist.children.each { |child| child.rm_r if child.basename.to_s != "stub.html" }
    (buildpath/"web/dist").children.each { |child| cp_r child, dist/child.basename }
    system "bun", "scripts/check-web-assets.mjs"

    ENV["CGO_ENABLED"] = "1"
    # DuckDB is linked dynamically against this formula via the duckdb_use_lib
    # tag, rather than the duckdb-go bindings' vendored static library.
    ENV.append "CGO_LDFLAGS", "-L#{formula_opt_lib("duckdb")}"
    # sqlite-vec's CGo binding #includes <sqlite3.h>; macOS provides it in the
    # SDK, while Linux needs Homebrew's sqlite headers.
    ENV.append "CGO_CFLAGS", "-I#{formula_opt_include("sqlite")}" if OS.linux?

    ldflags = "-X go.kenn.io/msgvault/cmd/msgvault/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, tags: "fts5 sqlite_vec duckdb_use_lib"), "./cmd/msgvault"
  end

  test do
    ENV["MSGVAULT_HOME"] = testpath

    port = free_port
    (testpath/"config.toml").write <<~TOML
      [server]
      api_port = #{port}
      daemon_idle_timeout = "10s"
    TOML

    cleanup_timeout = 10
    wait_for_child = lambda do |pid, timeout|
      deadline = Process.clock_gettime(Process::CLOCK_MONOTONIC) + timeout
      loop do
        result = Process.waitpid2(pid, Process::WNOHANG)
        return result.last if result

        remaining = deadline - Process.clock_gettime(Process::CLOCK_MONOTONIC)
        return if remaining <= 0

        sleep [remaining, 0.1].min
      end
    rescue Errno::ECHILD
      :reaped
    end
    terminate_and_reap_child = lambda do |pid|
      begin
        Process.kill "TERM", pid
      rescue Errno::ESRCH
        # The client exited after the deadline; reap it below.
      end

      status = wait_for_child.call(pid, 1)
      return status if status

      begin
        Process.kill "KILL", pid
      rescue Errno::ESRCH
        # The client exited while handling the timeout; reap it below.
      end
      Process.waitpid2(pid).last
    rescue Errno::ECHILD
      :reaped
    end
    run_child = lambda do |args, output, timeout = cleanup_timeout|
      pid = Process.spawn(*args, out: output.to_s, err: output.to_s)
      status = wait_for_child.call(pid, timeout)
      return [:reaped, nil] if status == :reaped
      return [:finished, status] if status

      terminate_and_reap_child.call(pid)
      [:timed_out, nil]
    end

    uri = URI("http://127.0.0.1:#{port}/")
    test_succeeded = false
    begin
      system bin/"msgvault", "daemon", "start", "--no-log-file"

      response = nil
      20.times do |attempt|
        begin
          http = Net::HTTP.new(uri.host, uri.port)
          http.open_timeout = 2
          http.read_timeout = 2
          response = http.get(uri)
          break if response.is_a?(Net::HTTPSuccess)
        rescue EOFError, Errno::ECONNREFUSED, Errno::ECONNRESET,
               Errno::ETIMEDOUT, Net::OpenTimeout, Net::ReadTimeout
          # The daemon can accept and close a connection while it is starting.
        end

        sleep 1 if attempt < 19
      end
      assert_kind_of Net::HTTPSuccess, response
      assert_match "<title>msgvault</title>", response.body

      assert_path_exists testpath/"msgvault.db"

      # Build the analytics cache, which runs DuckDB's Parquet ETL over the (empty)
      # database and so exercises the dynamically linked libduckdb.
      system bin/"msgvault", "build-cache"

      assert_match(/Messages:\s+0/, shell_output("#{bin}/msgvault stats"))
      test_succeeded = true
    ensure
      cleanup_errors = []
      stop_failed = false
      begin
        stop_result, stop_status = run_child.call(
          [bin/"msgvault", "daemon", "stop", "--no-log-file"],
          File::NULL,
        )
        case stop_result
        when :timed_out
          cleanup_errors << "Timed out stopping msgvault daemon during test cleanup."
          stop_failed = true
        when :reaped
          cleanup_errors << "Lost msgvault daemon stop child during test cleanup."
          stop_failed = true
        when :finished
          unless stop_status.success?
            cleanup_errors << "Failed to stop msgvault daemon during test cleanup."
            stop_failed = true
          end
        end
      rescue => e
        cleanup_errors << "Failed to run msgvault daemon stop during test cleanup: #{e.message}"
        stop_failed = true
      end

      if stop_failed
        # Give the configured idle timeout a small scheduling margin.
        sleep cleanup_timeout + 1
        begin
          status_file = testpath/"daemon-status.txt"
          status_result, status_status = run_child.call(
            [bin/"msgvault", "daemon", "status", "--no-log-file"],
            status_file,
          )
          if status_result != :finished || !status_status.success?
            cleanup_errors << "Failed to verify msgvault daemon shutdown during test cleanup."
          elsif status_file.read.exclude?("No msgvault daemon is running.")
            cleanup_errors << "msgvault daemon was still running after test cleanup."
          end
        rescue => e
          cleanup_errors << "Failed to verify msgvault daemon shutdown during test cleanup: #{e.message}"
        end
      end

      unless cleanup_errors.empty?
        message = cleanup_errors.join(" ")
        test_succeeded ? raise(message) : opoo(message)
      end
    end
  end
end
