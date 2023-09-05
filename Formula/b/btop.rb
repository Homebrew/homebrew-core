class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.2.13.tar.gz"
  sha256 "668dc4782432564c35ad0d32748f972248cc5c5448c9009faeb3445282920e02"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "377bedf756891fdf81312df0de7f6698653c00bb74cbfc21859402139af71c12"
    sha256 cellar: :any,                 arm64_big_sur:  "048387f6e5b471decca93682518d7e30f1300dbb5e22f4d0ecd771447276f512"
    sha256 cellar: :any,                 ventura:        "6c9f5da037520e6116a04ebf6c011a54aa38ff6d61d6b778266476985312f437"
    sha256 cellar: :any,                 monterey:       "13ff2c92dff4f98569dbcf19cd2d6d5eaa907485ce55fe3e6750eab687556ee3"
    sha256 cellar: :any,                 big_sur:        "b5215ec41daa2216f3312738d4bb2d6e225fba7d3a760cc629d91bcdfaf87972"
    sha256 cellar: :any,                 catalina:       "fffa1b48e2a7dec0da167a25aa411b87e28619dd72026e650239d8c3d6012df8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af5c08bf52c9d84b54b3fe3992240a50c048ff3b897e8ee13f428fac4db76e0f"
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
