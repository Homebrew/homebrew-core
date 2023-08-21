class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://github.com/azdavis/millet/archive/refs/tags/v0.12.9.tar.gz"
  sha256 "5063457adc4881ef76264a2de2c753f6165820e1dd4cbf3e77d002075a38c04d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f78ff194728358f34c73f19a33a455f852c65eb51ca5612bfd9bceb1d6dc778"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e832750c86341e9b14ad6615cd89c236408a6819d965b246d71e5c4ddbcd8a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82cae286319af061f333d79e781979746a6d0b030c2a3a1ba489341299c8535e"
    sha256 cellar: :any_skip_relocation, ventura:        "b88656fa28e59d97fb06d02a0d9c9b5baf546864d4921250e0ac17052945a561"
    sha256 cellar: :any_skip_relocation, monterey:       "bcd44636531a7bc7a1e6f3e8081211bc30a8bd12a3ea18142586e3911a20660d"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fdef8e0e6f78b4550eb1d465520aa295bc8fd3254e59e6cc433b082ae0496fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c58acfaa5f8a5130b4a64436cb35e12f98b467fde8f20fa42ae91a043ac0ce9a"
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
