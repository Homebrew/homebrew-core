class Inlets < Formula
  desc "Expose your local endpoints to the Internet"
  homepage "https://github.com/alexellis/inlets"
  url "https://github.com/alexellis/inlets.git",
      :tag      => "0.6.2",
      :revision => "fbc9f4fe98cf48e44300736140bd013d64d6f980"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/alexellis/inlets").install buildpath.children
    cd "src/github.com/alexellis/inlets" do
      commit = Utils.popen_read("git", "rev-parse", "HEAD").chomp
      system "go", "build", "-ldflags",
             "-s -w -X main.GitCommit=#{commit} -X main.Version=#{version}",
             "-a",
             "-installsuffix", "cgo", "-o", bin/"inlets"
      prefix.install_metafiles
    end
  end

  test do
    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    puts "Listening on: #{port}"

    (testpath/"ws_server.rb").write <<~EOS
      require "socket"
      require "digest/sha1"

      server = TCPServer.new("127.0.0.1", #{port})
      websocket_port = server.addr[1]

      loop do
        socket = server.accept
        puts 'Incoming Request'

        http_request = ""
        while (line = socket.gets) && (line != "\\r\\n")
          http_request += line
        end

        if matches = http_request.match(/^Sec-WebSocket-Key: (\\S+)/)
          websocket_key = matches[1]
          puts "Websocket handshake detected with key: \#\{websocket_key\}"
        else
          puts "Ignoring non-websocket connection"
          next
        end

        response_key = Digest::SHA1.base64digest([websocket_key, "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"].join)
        puts "Responding to handshake with key: \#\{response_key\}"

        response = "HTTP/1.1 101 Switching Protocols\\n" +
        "Upgrade: websocket\\n" +
        "Connection: Upgrade\\n" +
        "Sec-WebSocket-Accept: \#\{response_key\}\\n" +
        "\\n"

        socket.write response

        puts 'Handshake completed. Starting to parse the websocket frame.'

        count = 0
        loop do
          count += 1
          first_byte = socket.getbyte
          fin = first_byte & 0b10000000
          opcode = first_byte & 0b00001111

          second_byte = socket.getbyte
          is_masked = second_byte & 0b10000000
          payload_size = second_byte & 0b01111111

          keys = socket.read(4).bytes

          # Ping Message - see rfc6455
          if opcode == 9
            puts 'Received Ping'
            puts 'Sending Pong'
            output = [0b10001010, 0, ""]
            socket.write output.pack("CCA0")
          end

          # Exit after 2 ping-pongs
          if count == 2
            puts 'Exiting websocket server'
            exit 0
          end
        end
      end
    EOS

    pid = fork do
      exec "ruby ws_server.rb"
    end

    begin
      stable_resource = stable.instance_variable_get(:@resource)
      commit = stable_resource.instance_variable_get(:@specs)[:revision]

      # Basic --version test
      inlets_version = shell_output("#{bin}/inlets --version")
      assert_match /\s#{commit}$/, inlets_version
      assert_match /\s#{version}$/, inlets_version

      # Client websocket ping-pong test
      sleep 3 # wait for server to start
      output = shell_output("#{bin}/inlets client -r 127.0.0.1:#{port} -u http://127.0.0.1:8080 -p 1s 2>&1")
      assert_match %r{\sUpstream:  => http://127.0.0.1:8080$}, output
      assert_match %r{\sconnecting to ws://127\.0\.0\.1:#{port}/tunnel with ping=1s$}, output
      assert_match /\sPing duration: 1.000000s$/, output
      assert_match /\sConnected to websocket: 127.0.0.1/, output

      ping_ping_count = output.scan(/PongHandler\. Extend deadline/).size
      assert_equal ping_ping_count, 2
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
