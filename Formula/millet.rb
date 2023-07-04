class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://github.com/azdavis/millet/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "b16851bfb9eb6923244294eaf1619383b40ef6205db166d9985cbf018a25535d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ffd0086b24eec59da978cbf32416350625fb56afdf950001092eecae3772ef8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2cf825b71b88fe022a9f3906ef90955452e0d71f883849d2ee7e8342ff16537"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab239f14b62478bfb9eb0a1f6563db47600cad2dbcb9c231872f20c438b25f77"
    sha256 cellar: :any_skip_relocation, ventura:        "6f188ec08abace4af571e107b15094a56756621bc9a66803aa2ecd12ffab3384"
    sha256 cellar: :any_skip_relocation, monterey:       "82c78e64114f506268b2551c324bf026f8b4acfb6b8da2a8a2b321a67f5bc006"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd04f46f4127955bfc06661dea62cb63282c6d3f95d6e6d66bf1c7535071a45c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "512e8bfe11b0f82622cead9127fe3197f58573f7c50d320cadcaadb9d9407281"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/millet-ls")
  end

  test do
    initialize_request = { jsonrpc: "2.0",
                           id:      1,
                           method:  "initialize",
                           params:  { processId:    nil,
                                      rootUri:      nil,
                                      capabilities: {} } }

    initialized_notification = { jsonrpc: "2.0",
                                 method:  "initialized",
                                 params:  {} }

    shutdown_request = { jsonrpc: "2.0",
                         id:      2,
                         method:  "shutdown",
                         params:  {} }

    exit_notification = { jsonrpc: "2.0",
                          method:  "exit",
                          params:  {} }

    parse_content_length = lambda { |header_part|
      content_length_header = header_part.split("\r\n")[0]
      content_length = content_length_header.split(":")[1].to_i
      return content_length
    }

    read_header_part = lambda { |pipe|
      return pipe.readline("\r\n\r\n")
    }

    read_response = lambda { |pipe|
      header_part = read_header_part.call(pipe)
      content_length = parse_content_length.call(header_part)
      return JSON.parse(pipe.readpartial(content_length))
    }

    json_rpc_message = lambda { |msg|
      msg_string = msg.to_json
      return "Content-Length: #{msg_string.length}\r\n\r\n" + msg_string
    }

    send_message = lambda { |pipe, msg|
      pipe.write(json_rpc_message.call(msg))
    }

    IO.popen("#{bin}/millet-ls", "r+") do |pipe|
      pipe.sync = true

      # send initialization request
      send_message.call(pipe, initialize_request)

      # read initialization response
      response = read_response.call(pipe)
      assert_equal 1, response["id"]

      # send initialized notification
      send_message.call(pipe, initialized_notification)

      # send shutdown request
      send_message.call(pipe, shutdown_request)

      # read shutdown response
      response = read_response.call(pipe)
      assert_equal 2, response["id"]

      # send exit notification, which kills the child process
      send_message.call(pipe, exit_notification)

      pipe.close
    end

    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
