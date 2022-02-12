class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "09118f459321c0182df8e611ec5595db2ab5ca9e2cf3f0029cf4413f2497853b"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d9f3aacf8346fa09408c0d8d446a455a04c18833269ffab41019c9295ecaacd5"
    sha256 cellar: :any,                 arm64_big_sur:  "c51023f5259f2e9524afd77f714cc7a1882e3c50e4e32e26b2b90708df8e1417"
    sha256 cellar: :any,                 monterey:       "415af6fc8ba8029719878370061a76a7638f217248d6b1c89ce4f7606e9903dc"
    sha256 cellar: :any,                 big_sur:        "b554c6e739bfff023be61282a00d64341d4e151b9814e6b414baee1bb0c5f038"
    sha256 cellar: :any,                 catalina:       "68479a27848fba08e2579df2ec834a433026e12639c4b657dd245fabe3dffac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05c535ceb589907c66121f4b2acd54b5834dde12dba35658d1b1ad193d467f0d"
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
