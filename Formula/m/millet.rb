class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://github.com/azdavis/millet/archive/refs/tags/v0.13.4.tar.gz"
  sha256 "90cf2a5e0adb7a0477fc6eed52d394fbd397f421774682f89bf055f1a61ea8a3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea36c45eaddd8138dbf3e2bf034898802773e4f67e583f109b9d6884b1847eb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0316362ec635c62f94845b3f430b4b3e3f5d43f99ec1f9b27afff881a2b6d497"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a68b15893722b5deee976824e0beff9764d88f26e9c5a42dd6b2c0e6934275e"
    sha256 cellar: :any_skip_relocation, ventura:        "22f255d26d90c35fa6d997d0534f21c1023ea3d8bf19b19a7a8c62c51e4d1c39"
    sha256 cellar: :any_skip_relocation, monterey:       "5b4f16d898705f248935bcb7e3696cdcc343cea6ce2b29981559bead32936ba8"
    sha256 cellar: :any_skip_relocation, big_sur:        "29269d4bc13bb83b9bd9d7bc6d7b2cc7d20bca16d64981ff27fd7a4ebb78d267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28a9b6b42f96e2ddc761cd804ea5d531062007ce6ea9f4217098cbbaac918570"
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
