class Inlets < Formula
  desc "Expose your local endpoints to the Internet"
  homepage "https://github.com/inlets/inlets"
  url "https://github.com/inlets/inlets.git",
      tag:      "3.0.2",
      revision: "7b18a394b74390133e511957d954b1ba3b7d01a2"
  license "MIT"
  head "https://github.com/inlets/inlets.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "55fdb93d26dacaca8cbb42cc68b9387423e3b618220e57f9de67855209132eeb"
    sha256 cellar: :any_skip_relocation, big_sur:       "5d6d55f2b32adc41a92f908ee15b263f9090dad596d137bf448d0d224288f365"
    sha256 cellar: :any_skip_relocation, catalina:      "392626560257c399929a81954c6c20bc2f2485564b30597dd49ac85ffcb19a86"
    sha256 cellar: :any_skip_relocation, mojave:        "f87a32ce9f00b128379a23e83e62e2d9e4c811303c1b760cdde9cad16a599e99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc3dc0b39ea492fd4d00bef8ff4b5019567eb1e5fda0db6e7d7b276f46de4b4a"
  end

  disable! date: "2022-05-08", because: :repo_removed

  depends_on "go" => :build

  uses_from_macos "ruby" => :test

  def install
    ldflags = %W[
      -s -w
      -X main.GitCommit=#{Utils.git_head}
      -X main.Version=#{version}
    ]
    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" "), "-a", "-installsuffix", "cgo"
  end

  def cleanup(name, pid)
    puts "Tearing down #{name} on PID #{pid}"
    Process.kill("TERM", pid)
    Process.wait(pid)
  end

  test do
    upstream_port = free_port
    remote_port = free_port
    mock_response = "INLETS OK".freeze
    secret_token = "itsasecret-sssshhhhh".freeze

    (testpath/"mock_upstream_server.rb").write <<~EOS
      require 'socket'
      server = TCPServer.new('localhost', #{upstream_port})
      loop do
        socket = server.accept
        request = socket.gets
        STDERR.puts request
        response = "OK\\n"
        shutdown = false
        if request.include? "inlets-test"
          response = "#{mock_response}\\n"
          shutdown = true
        end
        socket.print "HTTP/1.1 200 OK\\r\\n" +
                    "Host: localhost:#{upstream_port}\\r\\n" +
                    "Content-Type: text/plain\\r\\n" +
                    "Content-Length: \#\{response.bytesize\}\\r\\n" +
                    "Connection: close\\r\\n"
        socket.print "\\r\\n"
        socket.print response
        socket.close
        if shutdown
          puts "Exiting test server"
          exit 0
        end
      end
    EOS

    mock_upstream_server_pid = fork do
      on_macos do
        exec "ruby mock_upstream_server.rb"
      end
      on_linux do
        exec "#{Formula["ruby"].opt_bin}/ruby mock_upstream_server.rb"
      end
    end

    begin
      # Basic --version test
      commit_regex = /[a-f0-9]{40}/
      inlets_version = shell_output("#{bin}/inlets version")
      assert_match commit_regex, inlets_version
      assert_match version.to_s, inlets_version

      # Client/Server e2e test
      # This test involves establishing a client-server inlets tunnel on the
      # remote_port, running a mock server on the upstream_port and then
      # testing that we can hit the mock server upstream_port via the tunnel remote_port
      sleep 3 # Waiting for mock server
      server_pid = fork do
        exec "#{bin}/inlets server --port #{remote_port} --token #{secret_token}"
      end

      client_pid = fork do
        # Starting inlets client
        exec "#{bin}/inlets client --url ws://localhost:#{remote_port} " \
             "--upstream localhost:#{upstream_port} --token #{secret_token} --insecure"
      end

      sleep 3 # Waiting for inlets websocket tunnel
      assert_match mock_response, shell_output("curl -s localhost:#{remote_port}/inlets-test")
    ensure
      cleanup("Mock Server", mock_upstream_server_pid)
      cleanup("Inlets Server", server_pid)
      cleanup("Inlets Client", client_pid)
    end
  end
end
