class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://github.com/azdavis/millet/archive/refs/tags/v0.14.4.tar.gz"
  sha256 "ab21e0178dd810c6426f167c4d333583b3e08785231a3bfee800778ca2aab9b2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2fcf324ac138e2f94107fa752ac435e04b9d9ef1b17facc85f2daaa55b6c6a84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f09517c6d8b5de2c3a5f53ca2b9cc2fe424674282a6c4351b275fba492f2f24d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c500f01099f631a3bde90628f5bfdd59d2c56085ac61d2032fa4462404e0b6a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1810a80f3dd0638d45430232727e429a54ecd3311a26bde348a7de3ed2390a1"
    sha256 cellar: :any_skip_relocation, ventura:        "67b02b7e0c67e8d4fa50e41ee35b2d4c671cf4899690d59a23c6f716524be161"
    sha256 cellar: :any_skip_relocation, monterey:       "72271b25b4f72a4853a376b0dcd5656c05e8b41c72c9aa21d38d83a228a808e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1426cd3aff539426fb9d240e29825e66532fd0a4189c3c1cf29531a5fe9569b3"
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
      content_length
    }

    read_header_part = lambda { |pipe|
      pipe.readline("\r\n\r\n")
    }

    read_response = lambda { |pipe|
      header_part = read_header_part.call(pipe)
      content_length = parse_content_length.call(header_part)
      JSON.parse(pipe.readpartial(content_length))
    }

    json_rpc_message = lambda { |msg|
      msg_string = msg.to_json
      "Content-Length: #{msg_string.length}\r\n\r\n" + msg_string
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
