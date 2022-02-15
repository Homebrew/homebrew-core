class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "8348bb37b642bf899b5ce0850d64e12cf9671c8c9624f3d21b58a015cd502107"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ec8b2efef8f849e062d55e003aa15cf9aaf1c988ece7908cc654e57e894d18da"
    sha256 cellar: :any,                 arm64_big_sur:  "a9c89bc80ce208d91ace1b65f40e99f08bd17985de3362247d77a136ac88ccba"
    sha256 cellar: :any,                 monterey:       "8be5e0c48512f87d73231e844b1ce5e449f2fed25b2f0c7bd58ea0e1e0510762"
    sha256 cellar: :any,                 big_sur:        "1a7ad33cc37021c4c38dfe235303726a84deb09e09daeb705f1f40c7ca16e118"
    sha256 cellar: :any,                 catalina:       "85e62c7b80d9aff4b94d9d7194c47d08b9c11a8625490a0eef641616ffb4696a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7352b5601def8eedc9332d1298321c5d65e359ffea27c468125ebc616ac49e7b"
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
