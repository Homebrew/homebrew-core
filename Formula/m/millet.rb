class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://github.com/azdavis/millet/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "072568064cd45e40820071f804effd3499704535e93581c5125cded329cba307"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "801863f0b88a656c7a35c22a0f8cd39871b96fe1006677cd3bdb82a2f4dfd3b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2748d87aaecd66e5c166d654e70eb2dab1c2307287e3e97b584dec115f2e814a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f84c0e76515019fb81520901d1ca462ac56d5f360537a8b41c257492906b4ea1"
    sha256 cellar: :any_skip_relocation, sonoma:         "4edf330cf968827d88859ece30639958373dc06d92c6a4ca2a4012d5cf77cc48"
    sha256 cellar: :any_skip_relocation, ventura:        "70c7babc7fd3f98bfaebcb15261b72eef6294283fa7356bf717ab226511d365e"
    sha256 cellar: :any_skip_relocation, monterey:       "b2fecd02fad27d7aba9c0bd602fea6615c621419ff02122fd1167284250e1d6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a36a0683046334958d49b6b2b876c362adb2d638e5b3e537f4a70260863cb89"
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
