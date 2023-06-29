class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://github.com/azdavis/millet/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "5702dd465445e13875ee50276de2b0883192f3b3d035dd36adec8fc88afb0605"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a149db2ec6a8f5038769c1dfcc7aea11f77c3d4866d84a77e066472e56030899"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ce65762ef6dfa28644e62fdde335c146ae8195aa5a7ab489c6c3f63a7f6e54e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a61b2b0a7548c8f970cd7ec1f42fef939437188f404aa29fadc1ce322269469f"
    sha256 cellar: :any_skip_relocation, ventura:        "1bbeb310a53c84b71e40e19c0bfc50a5d12721294e0c9b9032bdcce09026b3e4"
    sha256 cellar: :any_skip_relocation, monterey:       "bd4b6e343a3155749b2fe4f135bebcb34d41b4fb5f5f89415a4bed5b3d470c43"
    sha256 cellar: :any_skip_relocation, big_sur:        "8088cefbb1e6f6fda3f8c8cd2d36e435944ac4891a93f1cd69c5cc43d23b2431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87da2f9c509b0f397e836cb84bbdaa767ed59764a50b9e5cc2adf194ebca4d2a"
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
