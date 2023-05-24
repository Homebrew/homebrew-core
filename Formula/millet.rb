class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://github.com/azdavis/millet/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "480d7129a489e43798d98c960dab6f04c662f07ef90c44c668142cc47ee6108f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1942e20a1c25b63839b466ef66b302a141987afbd543e2bb9485972047b1f0a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9f0728ea3d73a22adbc3d97da2fc28746c57c9569dd7a04a1888e8c632f9d24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9c951cb9e83b7c142521c97bc7a2c16212abd7ddd3a7b2ce9356d44325c072f"
    sha256 cellar: :any_skip_relocation, ventura:        "42c37420b5eba6eb5022dcefa7eb2b47743e3783ee8c06e61f936aedc5c1682e"
    sha256 cellar: :any_skip_relocation, monterey:       "7529c954a85b35683476947e156246f1d6d68f1006064dfadca9fd10c47d40a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "aac40d2b8c7f42d90b5581efb648ec1dcccb420a376c6540b5f09bde2fd16480"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c2611c54766d7cc4281c81c83f656b98047af2e9a6959db4dfe647d161ba8af"
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
