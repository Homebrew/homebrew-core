class Clipper < Formula
  desc "Share macOS clipboard with tmux and other local and remote apps"
  homepage "https://github.com/wincent/clipper"
  url "https://github.com/wincent/clipper/archive/refs/tags/2.1.0.tar.gz"
  sha256 "9c13254e418a45c2577bd8a0b61d9736d474eec81947c615f48f53dacf3df756"
  license "BSD-2-Clause"
  head "https://github.com/wincent/clipper.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3c0df619d149a439aa768fe0ad2f378c814df645516f1b97e7208af8570e9bc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5ba6f81698c0137f48012644d531c866531753698d1401afbf4812ac6afac002"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4430a2ed4f0c3c46fbfbbe3b439ec13693f5d9b4d644a93a58abcda5ee22463"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "786decdda1515fb47e7defc2d5b4b8f8663ae3bc5af905a8333394404f5bac4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b590d188d9161d5bb518cd7459350e26884a94d0a6b34a28d88ff8a8bd7a6e26"
    sha256 cellar: :any_skip_relocation, sonoma:         "357b34301d35c90be7799c7cc702370ec0877e975e62c9033f2e2f1b8c5cfdf5"
    sha256 cellar: :any_skip_relocation, ventura:        "3af42ac07c4fd9f399ad8ddf10762d992610911b6afc59ea0ef02290d8c74b5b"
    sha256 cellar: :any_skip_relocation, monterey:       "86f8afc1e505c633c5c592cff7710184ce48e195ec038514682f1cdd78d3525c"
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
