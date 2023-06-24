class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://github.com/azdavis/millet/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "bf38da2981fd1067dd8e6f63063a446fb7b18b9e7db2d0f33439d1c708a40455"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd80cb37017f606803c3c7a7e22ab1c11ce5c9499f647b719a14ffba7994464b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1e9a79c449fe7f0a3334f0d7fa80bfe622fefa2a80777ad79d953002f88ded2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f355cad9851c961eb528cb24809e7eecc4180c956fac28e0b94463a0cfa4ca9f"
    sha256 cellar: :any_skip_relocation, ventura:        "0c689a74642a3486336f8802c554fa0dfa32d27b8d12bac7f9b426d22644398c"
    sha256 cellar: :any_skip_relocation, monterey:       "6ace0f9938022790a56dfeb17b2632ff37f66699f41d6b0ed2354a57f263a545"
    sha256 cellar: :any_skip_relocation, big_sur:        "88464e76764d1d64c04a2a1bdfffd553eb9f94e5731134994b8278cb3fddf845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae4469060e02b3bf7790032de8d3df59fc49c65f587617b70d638a948dd813f2"
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
