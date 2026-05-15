class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://github.com/azdavis/millet/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "ba5651ab14a07b2f2f09aad11f151e0fe4e767ccc4064122a5c56308c0320244"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4cc683cba304eb87085b60f70545616099a84d4281014ee93a30c2c366fb8b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "642268eddf5678529e58fc16636ddb2e38657177b798c6b1801d305c82264b9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6f8f6f5f7dcca843f574ff63d26e255518aba424c8e5fb7d49ec7ed0158f215"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0dc30970f99720b85a440850626df262fc71db4b4f74787fa5613afb4f6c97c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4219b0fd1cc06b6c02951a80618a11a522d9ede6227a586849b9c76cf7190c86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e18791bb10394022f41891876fdfa52f9eb4ab95022a986a60e7627cab22cc5"
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
