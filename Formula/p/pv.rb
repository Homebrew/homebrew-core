class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.10.4.tar.gz"
  sha256 "7e994f9b8645820a289288468051575adf09a1e688d8e4d8fa3ecc48778bf7c9"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "22e1c47e611c3a4ebcf00e9d734f3090e99d01f72b63f42c61b09648c47505e0"
    sha256 arm64_sequoia: "e70de5a9ef8ca1871686852d0fd2b8f107db36f0a95c163c7f0b2c61c83aaf11"
    sha256 arm64_sonoma:  "941e3405f08b77ce32a1c7eb9e3726bb5d1ac3379c368706ff6865bd55a17b15"
    sha256 sonoma:        "7625d4b3a375e9aa42272492f203b75bc85fa58a08109e27df0450d317e174eb"
    sha256 arm64_linux:   "e39f700322f7e94ac5222d556c2bbede097bd532b5924e06dcf8d75913aa5413"
    sha256 x86_64_linux:  "65d1557b8472572849ea3be19b58122c469abbbe653d6fb1a71c00b4171dfa14"
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
