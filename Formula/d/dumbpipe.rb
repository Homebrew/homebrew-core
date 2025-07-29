class Dumbpipe < Formula
  desc "Unix pipes that find a way between devices"
  homepage "https://dumbpipe.dev"
  url "https://github.com/n0-computer/dumbpipe/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "bb7bd90eacebe505f2c669e4e13dac57c43c9c0eb5eca94dfa1378fd7cdcda84"
  license all_of: ["MIT", "Apache-2.0"]
  head "https://github.com/n0-computer/dumbpipe.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"
    require "timeout"

    # Run `dumbpipe listen`
    listen_stdin, _, listen_stderr, listen_thr = Open3.popen3(bin/"dumbpipe", "listen")

    # Capture assigned `dumbpipe connect <ticket>`
    connect_cmd = nil
    Timeout.timeout(10) do
      while (line = listen_stderr.gets)
        if line.start_with?("dumbpipe connect")
          connect_cmd = line.strip
          break
        end
      end
    end

    # Run corresponding `dumbpipe connect <ticket>`
    _, connect_stdout, connect_stderr, connect_thr = Open3.popen3(connect_cmd)

    # Wait until ready
    Timeout.timeout(10) do
      while (line = connect_stderr.gets)
        break if line.start_with?("using secret key")
      end
    end

    # Send test message from listen to connect threads
    test_msg = "hello breworld"

    listen_stdin.puts test_msg
    listen_stdin.flush

    received = nil
    Timeout.timeout(5) do
      received = connect_stdout.gets&.chomp
    end

    assert_equal test_msg, received
  ensure
    Process.kill("TERM", listen_thr.pid)
    Process.kill("TERM", connect_thr.pid)
  end
end
