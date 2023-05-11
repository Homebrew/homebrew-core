class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://github.com/azdavis/millet/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "f0c385c85e90461d4bd6892fcd2a9449f93f7cf831dde6b7be1c71d856768617"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c095000b4428f668611b8daba19cd38983b3f559f8af8d131dd62adac2adde87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e0673f63bb020780acae01c2932df055be604752dde7e34b6a6953c7a76a354"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8868f15f65d8f2000e2940428e71f32ff2a60c095c4fac2f9c8796aa87e0b7a"
    sha256 cellar: :any_skip_relocation, ventura:        "29968e25842c881005d0ccbe0f66912a5b06dfedb2afc3802d217c2d75fae3f3"
    sha256 cellar: :any_skip_relocation, monterey:       "555c87055c97045d58e70f95ec210b45cf0982aa6838db2fd22aa0cc751f099e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8933dee42e7fef29de1072b155d6f5509b6e02e43a9f0fa2c1abf2c0b56f50fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fb762e72a259802027db487e2531d373613d7555a5c494361e9a762dec0f672"
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
