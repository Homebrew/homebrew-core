class Inlets < Formula
  desc "Expose your local endpoints to the Internet"
  homepage "https://github.com/inlets/inlets"
  url "https://github.com/inlets/inlets.git",
      tag:      "3.0.1",
      revision: "dbccc1ee8edfa0a06e4f7b258bbee4a959bc18af"
  license "MIT"
  head "https://github.com/inlets/inlets.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "49385530d15aed2d23ef0aed4f5f6b46cc6e6c49b0936a2b9995d95115cf88b8"
    sha256 cellar: :any_skip_relocation, big_sur:       "dd817356a0bccef76ee190e3ec5bd1a99965929b0e427697c8df0a4db088ab34"
    sha256 cellar: :any_skip_relocation, catalina:      "ae0b7a7acdf69fce8d9305cbd125083aff5f98e7ec0d1bdcf96aa26a4319fca1"
    sha256 cellar: :any_skip_relocation, mojave:        "1922d778ad53108052d204fe06122e7402ee5a28612c2e97f3ff78075b25cbae"
  end

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
