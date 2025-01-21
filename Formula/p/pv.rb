class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.9.27.tar.gz"
  sha256 "253659dc86569363f065f5e881e135a0c9594b987f34a19b104c7414a2d2c479"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "f0e0ecbb8f82b3279333c5bede070adb35efeb0f8120aee0565fe14c0335a26a"
    sha256 arm64_sonoma:  "eecbd790ff38b8221bf62a75f77b54a2bdcd8f2ef1fbfc3d6b45b3536ef3ab24"
    sha256 arm64_ventura: "ac7990fb6593e41cf7b245400b79f5a4cd54ce67ff5c90419fcb7d1b6669b20f"
    sha256 sonoma:        "b1154ad4be04f1436867c61db0dc82043037e2d5226e3453a0398cd3af4d1172"
    sha256 ventura:       "f244d11a89253241d51cd2d1f7a177113549d4cc4e13791021bcbd289cd1023b"
    sha256 x86_64_linux:  "b252505ed78cc76415bcb5d1da98a1708923c717740bf7b3ebba71833ce75813"
  end

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip

    assert_match version.to_s, shell_output("#{bin}/pv --version")
  end
end
