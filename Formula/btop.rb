class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.2.7.tar.gz"
  sha256 "60075824ca4e14c1ca920b76ffb101fc2340c5342f3ba600b5c280389b69bbbf"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "483f07d9774dc34f252a4ada0df375ea271be13ff0bccc5452d0a061c0109f42"
    sha256 cellar: :any,                 arm64_big_sur:  "ca8acbf95eb9729a4a7b97a8ebd8e766e8b12a4f17b749b1254edb6e3d4df2c4"
    sha256 cellar: :any,                 monterey:       "bc0a49cbc0e79fb37e22dbac644d78b130f916958d1959fa3b75687c812aac1e"
    sha256 cellar: :any,                 big_sur:        "624be0c9d476645e1ceef4c797c20de08879ea1a8bc3465bc18675b1ddf75571"
    sha256 cellar: :any,                 catalina:       "3caa152e8eaaebb17919e96e8b4f654c4927e2032b390e7d19fd0087957a7ef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "993f81d8e30d1dcd9dceac77433da31c9733856f40ee36daa66b59aaa861c7a8"
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
