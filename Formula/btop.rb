class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "8348bb37b642bf899b5ce0850d64e12cf9671c8c9624f3d21b58a015cd502107"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "171f2cd6d98930ab4503e03aad8d2860f65552f808884b72fb610a5764c21b5b"
    sha256 cellar: :any,                 arm64_big_sur:  "3072417bbee1e5a96b91e7f48817c82d331c1a463a1c49071787dedd641e9f33"
    sha256 cellar: :any,                 monterey:       "5eaf1a8087234d1249c37bc7b070a14af6898329f2d820f6f4a34af4f4ef56a2"
    sha256 cellar: :any,                 big_sur:        "fe60ab7af6792b8602e4c55d2e8ce672f0ca16012cc480092631315c5dbe88f5"
    sha256 cellar: :any,                 catalina:       "6adcfd37339ae1abb0ee312f8615a289cbdcf801d76898adbd93fef918f13a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0edb5a02fb09a666b77faa0b21317a2b52f70be9da503c452d424f6c228d987c"
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
