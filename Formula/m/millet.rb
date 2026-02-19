class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://github.com/azdavis/millet/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "32e76069e95e17dc00cd3ae6823300dde846b305633aeb571a9999e4d30bd1b9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "602d9efe3d160330dfc40b662ab1e3fd3254c7544741b603f1422a4edce5ccad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "564f8c256fca4a88991d6502f847536bf794bef91ce64c89b05e6ef3a7bc5715"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3953fc44fe8ed75723cb38d8ecaec016af0ad4793d0865034d42f26d69e6af47"
    sha256 cellar: :any_skip_relocation, sonoma:        "52982a72dbd15ab2fa525a85e76d7a6219b2cb11852c6d3c27f9761a056d8b16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fd6e9167bd12e3d6fd0dd75592c9589138d8b49706dfa03ac38113870dd51db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c368c30449aa0b21400effa109982de18688316887bc3ebc71e62a0767ca5a45"
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

    IO.popen(bin/"millet-ls", "r+") do |pipe|
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
