class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://github.com/azdavis/millet/archive/refs/tags/v0.14.6.tar.gz"
  sha256 "4367ef80056ab8a05bfef44d75725c63513126aa4cdfb970ff1c21e70ff65089"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e56a397ba1ffd324d8e4f3f3708562dd24d0a038f2f36da98e2b7281ffafc6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10b65b5b427901100c6a0878bd0a33b3b05e035a9727825fe01637a5ffb1743c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50cf4584a001d725de8399a2e645193427382c700f355fd930dab919a2852a53"
    sha256 cellar: :any_skip_relocation, sonoma:         "214761dcbef9aafcf4403d96ed44a55713a7c51c567bf8676006e8d9b01d52ae"
    sha256 cellar: :any_skip_relocation, ventura:        "4d8806b8754c80610e9981525c26dc16eecfdd4736fcca13beb333823d181b31"
    sha256 cellar: :any_skip_relocation, monterey:       "e6eebe59963a0b53c470bc0005f3321f8330ddd13e037752ee48e5decf3d1f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e0753bbc7aa809f8a9ac5f6eb04df8d5c078619093cce64493f7df0bfd29fca"
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
