class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://github.com/azdavis/millet/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "4464a777d3bda5fc4466fa5da93f6ec0e7d4f9d1d515bc2c088b0437404f267c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "139489d17bd1c671f96bfe0b5ce85b21ba427fd3c1ddc3f4459e28b53d99feab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d5a2de8bdf6c49b41a7d59bb3a1eb41a6e192f28f6de61fd11a4cf07aaa06ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdb30def1c38aa465b8815f29318c9325307dcb3da7586a5326fd06023627658"
    sha256 cellar: :any_skip_relocation, sonoma:         "793459cb49ad0a4717dee7110c3a5bf2e25f5dee18242aae699472b1f0159ddf"
    sha256 cellar: :any_skip_relocation, ventura:        "85190cf40e62b4de4a49a6ca1b26d3e0e71083a2af5e25fc114fbb2ca29c26ff"
    sha256 cellar: :any_skip_relocation, monterey:       "ad52d60263016066c18ac4a34934ad6e1f7404f7085c1fa4c4e3f4d0d969110a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8a99d18c9f9d888fcb7a6f2139612c25a24110a2bcbcc7f8383196b05326e89"
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
