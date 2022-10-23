class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.2.12.tar.gz"
  sha256 "158112184372ff93de68700ad7de12f91be0542c0ecf75ffb002326ecbb3ca76"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e85d13b4dfe30bc2fbeed3eb702ad4684b3f45ea40f1eb95aba91378f1a3192c"
    sha256 cellar: :any,                 arm64_big_sur:  "6040a2fd0ccb666fb70368e2d43e64dae315b80bb471d77c01c839d9a0b31e5d"
    sha256 cellar: :any,                 monterey:       "6f05ab003a5b3e084bb0ef338711faed3abe7f05570506d4029b7ca4d5eadae2"
    sha256 cellar: :any,                 big_sur:        "e18ca7dd812ad04ae0b8d6bf6692a4a08c9d73d8363145bbf591bf393cf213f9"
    sha256 cellar: :any,                 catalina:       "ab5cdaf932bdd2165f0d79c50366f9376a76bede5fe7396d370a7bd4cf00c405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ef569296cc78836e81543b1c45f0f35bb02d02bde7f753be2429360dc583f05"
  end

  on_macos do
    depends_on "coreutils" => :build
    depends_on "gcc"
  end

  fails_with :clang # -ftree-loop-vectorize -flto=12 -s

  fails_with :gcc do
    version "9"
    cause "requires GCC 10+"
  end

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
