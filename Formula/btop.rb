class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.2.9.tar.gz"
  sha256 "0f8c3434a9c4c132a34415a9cc4f048595b8a4d1a94e94223ac3a795e1c16531"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f84048ddc55ba0f2374aa1d971b0bfdff25ac79c15a7ecf89e9c0092fbe3e246"
    sha256 cellar: :any,                 arm64_big_sur:  "a6fd303e21613880e2a57c4d7e41e4a35f45fa61467006f98ed5927924c7224f"
    sha256 cellar: :any,                 monterey:       "5fd7676fdaf5d223fd27b717e6ed97ab6e2e8a69146951c84acd8a4948673b53"
    sha256 cellar: :any,                 big_sur:        "4e35cd0a9b6393019b75d8f8a7147571901f0960c31e299566df1e674979c126"
    sha256 cellar: :any,                 catalina:       "fedfbe0d6852d582eb39c6351978f867753b5ba50f0d18a1e18b4e371c2eb439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c5427ca6a651a32eafcb677b31133c8f46761effb92ed825818cfebab5ae73c"
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
