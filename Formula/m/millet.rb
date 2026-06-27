class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://github.com/azdavis/millet/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "dd0de00174182013543efe91e4755e56611fe872f40d5b9f1353b7a319d7f711"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecd593350008c6e56cef1227b949472011e3a373ded1f177d120fff19c83f455"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79e6cf5cbe43cd791c0e7d7b056d84f7ad2efd17d16244e0dc46b026ad3821b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cde2ae38e21fb8ac20e67807b869ae61e3e046001bb5f12fcdc129d3b4ba9a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ead9867137f148dfde3dde8b2ea9c995b0b8ea602d47f9c42544418ec97159a8"
    sha256 cellar: :any,                 arm64_linux:   "76c1bee8d56109eeae4011b20288dc9d04bdab4ab79bb72902851e6f4e12d37f"
    sha256 cellar: :any,                 x86_64_linux:  "c0a7daf887dc5a0aadfba3dff6f7108970f33fe4b99269019b1e2065a7cbc202"
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
