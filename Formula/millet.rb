class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://github.com/azdavis/millet/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "b957b7dfc12d261376feca73221f75c12af2bfbd3ac82c1b3e9d0f49fe750728"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c7b646cff2f580ca55439caf5477436a67e97ebd2ad7d506fafe13ec2cdef2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34a4733bbb7fd2d1a2dd2af5bf6f8cb3f5d217e7d049a2a90a5dd04fdbcdbbf4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11e46965ddfef829edecbc438d6ae7bd76263d237765e48862a41b842c0ed376"
    sha256 cellar: :any_skip_relocation, ventura:        "dc44f56dbb64d7e95a7c0e24c2a90e9d3743608d0cab02aadd1f1cfc6ea75384"
    sha256 cellar: :any_skip_relocation, monterey:       "c41fd9812e966a10d7a17f2573acf65e860d21b81a2183a6c1ae06304a57602b"
    sha256 cellar: :any_skip_relocation, big_sur:        "26168ed53f7745426e57202c9b794efb5061d3b768a1c6411fd0c4889164e8ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d473d1c268d09b8a877a0aabd2296be5c182382660b029e2832f8cda41533068"
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
