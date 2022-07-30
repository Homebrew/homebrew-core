class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  license "Apache-2.0"
  revision 2
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
    sha256 cellar: :any,                 arm64_monterey: "590514c049d0ab867fc6b3edbbe7ab4f4ea43a45c42457264c374ccabcaee50e"
    sha256 cellar: :any,                 arm64_big_sur:  "afb8207aaff39a0f31fc9588eb8899a12f7fede8cc4efdc773950d7c31b0e8b4"
    sha256 cellar: :any,                 monterey:       "1362e399ab44e9bc45c293df0a4ade56f3d85304fd5513d39b4fd1237486bda1"
    sha256 cellar: :any,                 big_sur:        "8bd4e6311266d3e0d7e305cfdd5fee3883f80103e38fd11483113246097de648"
    sha256 cellar: :any,                 catalina:       "44c0cc9d02bb4462225357cfb6e7c487ccc0882780660e7dc14648fa8673341b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82b31d1cfe04dc8ff6dada258e97ca4adef9a47acfb0f1239759ed6a1bd7bd8d"
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
