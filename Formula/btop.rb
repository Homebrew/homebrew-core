class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "3631f39c847c884064dd0babf34487a3b8b87a9d61d89aa5185418ffdc4741d8"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "33854462dd40ee379a959bd9937ba5e6dc5c3343e4cceac072293ee2f482f160"
    sha256 cellar: :any,                 arm64_big_sur:  "bd900371eed68a4cf847ebd74b33acd908f197d3aeacfeb5f7414635968debc8"
    sha256 cellar: :any,                 monterey:       "7369f70c7b411eccf40599b72eeafce4d09f71ce8ab64e69f72053c445841370"
    sha256 cellar: :any,                 big_sur:        "455420362f9f99a7682949e5e55f1600f07f21e18b61f566c18ea26601aef558"
    sha256 cellar: :any,                 catalina:       "a44de54fa0dbd4f62567596fccc0382541aa5b6878ce727bc90149b5d566bf8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faaf0ed11d7952a2f3bf77f609469ad9ae0022f283946bb4780289c593079daa"
  end

  depends_on "coreutils" => :build
  depends_on "gcc"

  fails_with :clang # -ftree-loop-vectorize -flto=12 -s
  # GCC 10 at least is required
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with gcc: "8"
  fails_with gcc: "9"

  def install
    system "make", "CXX=#{ENV.cxx}", "STRIP=true"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    config = (testpath/".config/btop")
    mkdir config/"themes"
    (config/"btop.conf").write <<~EOS
      #? Config file for btop v. #{version}

      update_ms=2000
      log_level=DEBUG
    EOS

    require "pty"
    require "io/console"

    r, w, pid = PTY.spawn("#{bin}/btop")
    r.winsize = [80, 130]
    sleep 5
    w.write "q"

    log = (config/"btop.log").read
    assert_match "===> btop++ v.#{version}", log
    refute_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
