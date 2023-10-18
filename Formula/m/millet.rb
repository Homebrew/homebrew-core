class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://github.com/azdavis/millet/archive/refs/tags/v0.13.5.tar.gz"
  sha256 "7ea921decaa4a08a47ab5ec12960ecefdc9349d6f1168885bfb7b241f658e398"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "856de65034282520fe69bef37febdcce741c9cde94fa602c6b0674f65058c442"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8210f135f9fb9f998546ef1b88e8db7cd4ec160a5875d8a14e93e21a8d876dd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f16546a4f64571da55d717787402098209be02a8539b909e31cc436221c4ed6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "7492d3747e3228ffff9a3b13abc5b8bf45fd1237eae683fdd2e0d9b6671a57a4"
    sha256 cellar: :any_skip_relocation, ventura:        "66e74b2f8caa0411109dfe64cffb0705075f9efa059a1b31bbb38b71429a06c5"
    sha256 cellar: :any_skip_relocation, monterey:       "c8dfc6b8822a24b739dceecec81c50fd6614fc16f5b5f2767117ab11130c9d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac6d47a4345d743bff322ddaa0dd4c9aaa7c40a8a61e3d6a2486afce16227e3c"
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
