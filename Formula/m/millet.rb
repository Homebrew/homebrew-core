class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://github.com/azdavis/millet/archive/refs/tags/v0.14.9.tar.gz"
  sha256 "5efff3cafade17b33a8b9b2748a8c064dbd51932934de01f8d2a14c88ac829c5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90b980de74d6d62275bff7eafa02ac70355099668190ee3e108ed6d4332f6e71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4461ab5dae2b2e3216a970e293c5b7287a685cd2227d3a9fe9484d3c4b5a334"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c90a66817e56189faf6b56cf3c5f257d7e281b5de0c4b1642a1e08fd10ec5121"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d6cc53a1c690a8aca2ec156245e57eab2ff0ac033c6f9902f3f0c19b568912c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c1473be0100ce02de27fb0ab410d04c7318053f969d215a2d5e8569925ce935"
    sha256 cellar: :any_skip_relocation, ventura:       "0cd78d743593adb18fd831df1d7dd3fb48bab36b9b37f97bee4ecc52996a1fb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9026943a06ceae4faf4de5dd51d7817b8c32fe161920448b03fae147d27e9bc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad26eaf3f79857774cf8b33f0d09ef507245473871b0df9c8c6fbed9521b1365"
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
