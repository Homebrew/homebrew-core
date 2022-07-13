class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  license "Apache-2.0"
  revision 1
  head "https://github.com/aristocratos/btop.git", branch: "main"

  # Remove stable block when patch is no longer needed.
  stable do
    url "https://github.com/aristocratos/btop/archive/refs/tags/v1.2.8.tar.gz"
    sha256 "7944b06e3181cc1080064adf1e9eb4f466af0b84a127df6697430736756a89ac"

    # Fix finding themes on ARM
    # https://github.com/aristocratos/btop/issues/344
    # https://github.com/Homebrew/homebrew-core/issues/105708
    patch do
      url "https://github.com/aristocratos/btop/commit/a84a7e6a5c3fe16b5e1d1a9824422638aca2f975.patch?full_index=1"
      sha256 "f7dd836f5fcb06fe4497e9d7f2c0706bbe91a1b8a1d9b95187762527372fb38c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2047180f8bce7ebd6cf3c3ce644c41cdcff0a9962546757cb0e0fbae09324389"
    sha256 cellar: :any,                 arm64_big_sur:  "e91f7e48d191e82e71d106497dcf2c0f939024fa192064f2a4c68cbd2daae7ba"
    sha256 cellar: :any,                 monterey:       "42d4b325c305cf4aa9ab2279cf1859f0ddfe183c2ad9b82e74a71af1c25db777"
    sha256 cellar: :any,                 big_sur:        "6514030dc05358a2520e2423e07237cf21d288106db82f83623e6c92b6aaa7e9"
    sha256 cellar: :any,                 catalina:       "b98a1fb59a807907521d894d4551ce316fd2d4068963b2ce9c16eb5a4f72310d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ed4c1b25f015d0d7d9a9b8696c88d51c5407adb999cfb8cf2d81713bf6120fa"
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
