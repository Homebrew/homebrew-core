class Inlets < Formula
  desc "Expose your local endpoints to the Internet"
  homepage "https://github.com/inlets/inlets"
  url "https://github.com/inlets/inlets.git",
      :tag      => "2.7.0",
      :revision => "ced556795aecc6e2ac514032e78f3096d17bfa25"

  bottle do
    cellar :any_skip_relocation
    sha256 "d49fb89dc621c3a94e38a1ba4ce40e0d1ca40a8a7609b6b0934f449d2bb4192e" => :catalina
    sha256 "6bbfc25c045ba3b6c5ac7891c41d6e27e2850281afb97b717a5beebf266b5b07" => :mojave
    sha256 "bbe5682309639393ad89d4cadd86791283c90fc04e55c6ec032ea8f9af5560d7" => :high_sierra
  end

  depends_on "go" => :build

  uses_from_macos "ruby" => :test

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/inlets/inlets").install buildpath.children
    cd "src/github.com/inlets/inlets" do
      commit = Utils.popen_read("git", "rev-parse", "HEAD").chomp
      system "go", "build", "-ldflags",
             "-s -w -X main.GitCommit=#{commit} -X main.Version=#{version}",
             "-a",
             "-installsuffix", "cgo", "-o", bin/"inlets"
      prefix.install_metafiles
    end
  end

  def cleanup(name, pid)
    puts "Tearing down #{name} on PID #{pid}"
    Process.kill("TERM", pid)
    Process.wait(pid)
  end

  MOCK_RESPONSE = "INLETS OK".freeze
  SECRET_TOKEN = "itsasecret-sssshhhhh".freeze

  test do
    upstream_server = TCPServer.new(0)
    upstream_port = upstream_server.addr[1]
    remote_server = TCPServer.new(0)
    remote_port = remote_server.addr[1]
    upstream_server.close
    remote_server.close

    puts "Starting mock server on: localhost:#{upstream_port}"

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
          response = "#{MOCK_RESPONSE}\\n"
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
      require "uri"
      require "net/http"

      stable_resource = stable.instance_variable_get(:@resource)
      commit = stable_resource.instance_variable_get(:@specs)[:revision]

      # Basic --version test
      inlets_version = shell_output("#{bin}/inlets version")
      assert_match /\s#{commit}$/, inlets_version
      assert_match /\s#{version}$/, inlets_version

      # Client/Server e2e test
      # This test involves establishing a client-server inlets tunnel on the
      # remote_port, running a mock server on the upstream_port and then
      # testing that we can hit the mock server upstream_port via the tunnel remote_port
      puts "Waiting for mock server"
      sleep 3
      server_pid = fork do
        puts "Starting inlets server with port #{remote_port}"
        exec "#{bin}/inlets server --port #{remote_port} --token #{SECRET_TOKEN}"
      end

      client_pid = fork do
        puts "Starting inlets client with remote localhost:#{remote_port}, upstream localhost:#{upstream_port}, token: #{SECRET_TOKEN}"
        exec "#{bin}/inlets client --remote localhost:#{remote_port} --upstream localhost:#{upstream_port} --token #{SECRET_TOKEN}"
      end

      puts "Waiting for inlets websocket tunnel"
      sleep 3

      uri = URI("http://localhost:#{remote_port}/inlets-test")
      puts "Querying upstream endpoint via inlets remote: #{uri}"
      response = Net::HTTP.get_response(uri)
      assert_match MOCK_RESPONSE, response.body
      assert_equal response.code, "200"
    ensure
      cleanup("Mock Server", mock_upstream_server_pid)
      cleanup("Inlets Server", server_pid)
      cleanup("Inlets Client", client_pid)
    end
  end
end
