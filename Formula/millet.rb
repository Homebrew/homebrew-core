class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://github.com/azdavis/millet/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "06ff052560b59221d3ebc0803946c239d0d5229e97ae9f34718d2d0853d90aa3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2545a803b31326378f97d85ab8d81597c745fb3f8916b200661ac1deff237b06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d90e43f106bec5ef252b0b5cca30c9955c4b1cd9e206598eb388129cd8d5164"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5121972f7f5cee47d7454834a626e0a8fed13815153a2439cd7a7ffa39ff9666"
    sha256 cellar: :any_skip_relocation, ventura:        "a1d9e42c257cb80ccc0d4cf51969d4353cff3baae1c91f4e93f6f25b2391cd8b"
    sha256 cellar: :any_skip_relocation, monterey:       "8b3245eac2232131c010b6f36a2d5275fe5cf317125bf62de3e468a4342ba886"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc8eaf57b0b546b4f9dcc5a453231b234c0f44c86f4caa20925d2cd0aad19702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "432b58fc390eac6e865b54022e56986406de379f78a70aa22084c1d79894ae4b"
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
