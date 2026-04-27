class Clipper < Formula
  desc "Share macOS clipboard with tmux and other local and remote apps"
  homepage "https://github.com/wincent/clipper"
  url "https://github.com/wincent/clipper/archive/refs/tags/3.0.0.tar.gz"
  sha256 "0008c6147a365658c30a556956e923f49b296e76872febf600bfb9c5ffbc6bd0"
  license "BSD-2-Clause"
  head "https://github.com/wincent/clipper.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44b24d4c30b5e9f0b830a3c4f9189bac8f62d4e84c1a268493b3a36eff3a1b7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44b24d4c30b5e9f0b830a3c4f9189bac8f62d4e84c1a268493b3a36eff3a1b7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44b24d4c30b5e9f0b830a3c4f9189bac8f62d4e84c1a268493b3a36eff3a1b7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1e008969ac9bb3e7978963fc1c43d22514338f9a255a57e99d45ad4581ae990"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "clipper.go"
  end

  service do
    run opt_bin/"clipper"
    environment_variables LANG: "en_US.UTF-8"
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    test_data = "a simple string! to test clipper, with söme spéciål characters!! 🐎\n".freeze

    cmd = [opt_bin/"clipper", "-a", testpath/"clipper.sock", "-l", testpath/"clipper.log"].freeze
    ohai cmd.join " "

    require "open3"
    Open3.popen3({ "LANG" => "en_US.UTF-8" }, *cmd) do |_, _, _, clipper|
      sleep 0.5 # Give it a moment to launch and create its socket.
      begin
        sock = UNIXSocket.new testpath/"clipper.sock"
        assert_equal test_data.bytesize, sock.sendmsg(test_data)
        sock.close
        sleep 0.5
        assert_equal test_data, `LANG=en_US.UTF-8 pbpaste`
      ensure
        Process.kill "TERM", clipper.pid
      end
    end
  end
end
