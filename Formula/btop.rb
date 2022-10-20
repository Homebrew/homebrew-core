class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.2.9.tar.gz"
  sha256 "0f8c3434a9c4c132a34415a9cc4f048595b8a4d1a94e94223ac3a795e1c16531"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4f4b48b9eaba26168dd81a917d6ae1b04210cbe4cc9af2f8ecfe2a867d94c8a6"
    sha256 cellar: :any,                 arm64_big_sur:  "23149f286020650edd9bc451e573c4eeb4977175dfa99372bd3ca5c577073a0a"
    sha256 cellar: :any,                 monterey:       "af7e00a1ccf7f09e651f847ddc9bbd1eda8b074f03b6d6cc72361415b0ab6782"
    sha256 cellar: :any,                 big_sur:        "ccfe0082b2f77431191d6fb3a028c288db9728c8462f019fda79bd05abce9798"
    sha256 cellar: :any,                 catalina:       "8d51d9b61e209f0de790c7f02d3ebce9368282142cd755f6fb95a0990b1455e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "177872d7a8a5e136fc90a82b2d9ea796beb9343b156c9cd880e4f5eef783918e"
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
