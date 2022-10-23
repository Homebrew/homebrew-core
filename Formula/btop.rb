class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.2.9.tar.gz"
  sha256 "0f8c3434a9c4c132a34415a9cc4f048595b8a4d1a94e94223ac3a795e1c16531"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "35e0c3784bc09e4d618ecb5e249760a33c1ac7c30ba02385e9f8b28cfc381c9b"
    sha256 cellar: :any,                 arm64_big_sur:  "6809aa83a8ef5af3d2b6035f7f376c597824bc5ac97ec827f2edcfa5ac0b1034"
    sha256 cellar: :any,                 monterey:       "4d7795c2c21696cd965a7af36e379a5d05c24cf138500b1c986fcab38d9eaed6"
    sha256 cellar: :any,                 big_sur:        "be7d212beee7463eba6e835a787e96738de51e5381712d5bd88090625586a637"
    sha256 cellar: :any,                 catalina:       "15dfadf05671b479ee496caf3ce9453c95462f52c92d7cf9a114c2b6a733f439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a47dda9b7a635733e5a5add63889afe4a3504671f412a2119ea3bd7f0da03852"
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
