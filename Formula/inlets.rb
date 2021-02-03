class Inlets < Formula
  desc "Expose your local endpoints to the Internet"
  homepage "https://github.com/inlets/inlets"
  url "https://github.com/inlets/inlets.git",
      tag:      "2.7.12",
      revision: "448880e64b35b4027321cc4f328392649dca923c"
  license "MIT"
  head "https://github.com/inlets/inlets.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7e8c975df59151c14040f9188c727667309c93025f92ea9ef2caac82515af64a"
    sha256 cellar: :any_skip_relocation, big_sur:       "4c89bedf66827ec3d8247a195a997de7bd7df075ae78cc74c1af408b4a6c3d49"
    sha256 cellar: :any_skip_relocation, catalina:      "2a0d9aa35bd843b2ed9773cee4b7b05c02b21cbcb78b085bb1c73363dc8a8ec4"
    sha256 cellar: :any_skip_relocation, mojave:        "b1c8a139e4d6f18c666d7f6380bfad18ea3d8836c6aa394c5026e1e872840225"
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
