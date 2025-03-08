class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://github.com/azdavis/millet/archive/refs/tags/v0.14.8.tar.gz"
  sha256 "8009a3441eba86d965de1482b1453947b21d36fe94f2287735a39e2d7bfe2ca4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb302fc566189bc784b66c41e349e3f3fc7b0f5a0796b4ed993fc1a828aca678"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "439a08b77bae4e8e6ae6f0a818734284632071582d1a65baf45f2865b438c15d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed41078db233116bd6339fd1310b21836c69a18f6adfb797e120959dfa645296"
    sha256 cellar: :any_skip_relocation, sonoma:        "51eb5c7b5c5444577af054c15e57396877acf8c06aa5a2eba362dd4d3d74860d"
    sha256 cellar: :any_skip_relocation, ventura:       "879e9aadf0be9827af083b1153e1375c466edb15df4129137dfeabe35b126147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5870da021524dd1a04cf8e9a8942d4d5a45e6e8482af1f40cfcc9a493f2ebe4"
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
