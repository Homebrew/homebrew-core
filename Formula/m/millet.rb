class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://github.com/azdavis/millet/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "2a2f2283bc2f21aee06e63cb8e4cd671bab2441dcdb24e280028234b50acf657"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12462f86bb392c0729b3e7d08fc1fc0d95b5a85d9909652e698ea9ca03ae8c32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42dabbe4c0c188ecbb06526ed5efd601792fefa764316e839dd6f326441ce2e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2277b06c23c5c3ee912df693de943a3bd333051f3746148e62156a3ca41598ab"
    sha256 cellar: :any_skip_relocation, ventura:        "eef5c2b6e1dc1b87be635f6c44400345f79cd947f34944beab218d571faeecae"
    sha256 cellar: :any_skip_relocation, monterey:       "13cb147d10d17b03eb8c0b8177e6a4e6cfdec45caa267f70fabed2b60d6118bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ae4185ca89389efb3a789b8e47875843958fe7b0cb5e8e1e3c5935812fd8742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "502b9a88d2a6c8b0b1a309e858f0e092521bab8bd7458077709bc0c82ac5b2dd"
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
