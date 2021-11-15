class Ogmtools < Formula
  desc "OGG media streams manipulation tools"
  homepage "https://www.bunkus.org/videotools/ogmtools/"
  url "https://www.bunkus.org/videotools/ogmtools/ogmtools-1.5.tar.bz2"
  sha256 "c8d61d1dbceb981dc7399c1a85e43b509fd3d071fb8d3ca89ea9385e6e40fdea"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?ogmtools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "34cfdabab2892f91fd6a6164a041f62eef1da1cf7a2097ad5fe5e2e904de21a3"
    sha256 cellar: :any,                 big_sur:       "939be64a395371009f70c9c596e86df908e429ad6915dee142752c1114f2e1d3"
    sha256 cellar: :any,                 catalina:      "6a2e3ed95e0569dca709b5d0431ea309c008400f3f88b91133d6854340babed7"
    sha256 cellar: :any,                 mojave:        "0c4c8271cbdc79f5d444aca60f7e32c489961f364923e475107021f857122b64"
    sha256 cellar: :any,                 high_sierra:   "c84b3fe9a525a0f6719bab86a5b919af73b067b48134e9b9ff3225af9b728260"
    sha256 cellar: :any,                 sierra:        "ec07a396ce68d5c646c838e3129dbe6c8ca8ff7ea9126cd31f9844016582d0ec"
    sha256 cellar: :any,                 el_capitan:    "8e0ceae59b3a69647511dff89566a734d25a96a764893c7599ee1ece73890db5"
    sha256 cellar: :any,                 yosemite:      "3a43fec619944cd6fa8e57bd067477ef63997919e11174ddafb160c47b28fd5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bd76fd65c8b1627890beef905c7b8eb23119ace422c6618be47a9412862479c"
  end

  depends_on "libogg"
  depends_on "libvorbis"

  # Borrow patch from MacPorts
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e4957439/ogmtools/common.h.diff"
    sha256 "2dd18dea6de0d2820221bde8dfea163101d0037196cb2e94cd910808d10119c0"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  # Borrow warning from MacPorts
  def caveats
    <<~EOS
      Ogmtools has not been updated since 2004 and is no longer being developed,
      maintained or supported. There are several issues, especially on 64-bit
      architectures, which the author will not fix or accept patches for.
      Keep this in mind when deciding whether to use this software.
    EOS
  end
end
