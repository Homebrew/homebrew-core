class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://github.com/azdavis/millet/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "262d5186f150e51fc387911e6dca93d6bf8e217445b49ead0f54b45f39234c2e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aae0481e2638c23b89241503bd3bc67b62190bfec8b57892bbd92e42b8c493b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c43be03b6d7f3284361eba676ed1f356cb03bccb1c9fe489ec04c24a60644fe6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "232e5df0e647a7ee3ddd2f473ab67bf7b4b134275b924af8e0979e09371ca68a"
    sha256 cellar: :any_skip_relocation, ventura:        "3b8e7a6e5d9932b5f8e47457e27a48af29c1f2415c4ddb55427b4dc0701403af"
    sha256 cellar: :any_skip_relocation, monterey:       "57dd0a527700451ff232480ee1d7fa2ca4d024fc65addabdec965207a64984ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d66e16ff619fe9e925aed35e5d9e17741ce9d3cb2354af0c295a393ff729f68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e21a091f6a14869b3a1348519013d04b9e525277be706eb63248c4a876185b2"
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
