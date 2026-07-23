class Clipper < Formula
  desc "Share macOS clipboard with tmux and other local and remote apps"
  homepage "https://github.com/wincent/clipper"
  url "https://github.com/wincent/clipper/archive/refs/tags/3.0.0.tar.gz"
  sha256 "0008c6147a365658c30a556956e923f49b296e76872febf600bfb9c5ffbc6bd0"
  license "BSD-2-Clause"
  head "https://github.com/wincent/clipper.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a774abbbe9a959f39a478a85b38f06ee5991ffd4eeb2d6314d242da59ed5402"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a774abbbe9a959f39a478a85b38f06ee5991ffd4eeb2d6314d242da59ed5402"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a774abbbe9a959f39a478a85b38f06ee5991ffd4eeb2d6314d242da59ed5402"
    sha256 cellar: :any_skip_relocation, sonoma:        "82e62e607c9831b635560f0783e52f3d3f1a98bda6a0fc8083f61629b9423b79"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    clipper_version = if build.stable?
      version.to_s
    else
      Utils.safe_popen_read("git", "describe", "--tags", "--dirty").chomp
    end

    ldflags = %W[-s -w -X main.version=#{clipper_version}]
    system "go", "build", *std_go_args(ldflags:), "clipper.go"
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

    version_output = shell_output("#{bin}/clipper -v 2>&1")
    assert_match version.to_s, version_output
  end
end
