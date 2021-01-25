class Inlets < Formula
  desc "Expose your local endpoints to the Internet"
  homepage "https://github.com/inlets/inlets"
  url "https://github.com/inlets/inlets.git",
      tag:      "2.7.10",
      revision: "9bbbd0ef498474b922830bd2bfaa6a1caf382660"
  license "MIT"
  head "https://github.com/inlets/inlets.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "052259d2a17d8b058731069a1f9ab758666a627de97b50f26ebb1fa8a5eeed8f" => :big_sur
    sha256 "85770ec2c276a31514842136787a23c3f831a6c1f298948d86de2e4a0ec1a741" => :arm64_big_sur
    sha256 "233946f3d8ba38a665c5616ccb9f8431bcd99ac70648527814ee391bf589b0d4" => :catalina
    sha256 "bc39ad9bd53852afeff5018f5ce7de82676df575c7d45c3d71e1eb93a04eabce" => :mojave
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
      exec "ruby mock_upstream_server.rb"
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
        exec "#{bin}/inlets client --remote localhost:#{remote_port} " \
             "--upstream localhost:#{upstream_port} --token #{secret_token}"
      end

      sleep 3 # Waiting for inlets websocket tunnel
      assert_match mock_response, shell_output("curl -s http://localhost:#{remote_port}/inlets-test")
    ensure
      cleanup("Mock Server", mock_upstream_server_pid)
      cleanup("Inlets Server", server_pid)
      cleanup("Inlets Client", client_pid)
    end
  end
end
