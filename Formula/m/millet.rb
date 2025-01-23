class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://github.com/azdavis/millet/archive/refs/tags/v0.14.7.tar.gz"
  sha256 "5971d48101549ceeb2cdee4e3863c52821fd438c1e27a40dd8892220f447f4b6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f28322be48cbcab756a89b808173b794070b574e7d1bee162848cb1e4155967"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "469d45f934becf09462d6f5a24970eab07b142ee95d591813870819f6d5ed985"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a81e0d2237392a1a8fa19f9cf0127eec2b119dfc266c836b74de7047202be89d"
    sha256 cellar: :any_skip_relocation, sonoma:        "183a1eaa2cca28c6e5ea44cdde478c691504dbbb4ca8f017f4cc670557984f42"
    sha256 cellar: :any_skip_relocation, ventura:       "29169df7ccdaf3422f073d9a771c999eaa5fc0e2018ad867bfe3eac9e6793e4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96064a8f9bbfe20287b0c8e122f9df0dd67bb91f81dcea4e7e69c16345449885"
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
