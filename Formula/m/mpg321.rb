class Mpg321 < Formula
  desc "Command-line MP3 player"
  homepage "https://mpg321.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mpg321/mpg321/0.3.2/mpg321_0.3.2.orig.tar.gz"
  sha256 "056fcc03e3f5c5021ec74bb5053d32c4a3b89b4086478dcf81adae650eac284e"
  license "GPL-2.0-or-later"
  revision 3

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "4582777d133873930312cc1c4314d0997e3219f582b07c771a4f413b5cb0cfc5"
    sha256 arm64_sequoia:  "ed6f4de0b208b65bdc562fefd7f6cd8dbad5b6489b52bc24b4bf9109de4b6f35"
    sha256 arm64_sonoma:   "00b92592cadd767c25fe24941095b6f6f088cf319b25ab78a83d0a75797e7a43"
    sha256 arm64_ventura:  "963826c2df80f72ba7e5ca28ca63c29484ce57dee4056ab4e54677e166a2f4a2"
    sha256 arm64_monterey: "7060caabffb689d03eae5d98b62caa894655c7e29201c432afe5ec1ae5864301"
    sha256 sonoma:         "1a50f4f46de3340e25159744cfe7b8fb1c365f3aded9339ec723516e8bf91925"
    sha256 ventura:        "c9ab1dd71ff6f687fa35938d31af37377e340c910492d5a46e907cf8a498b379"
    sha256 monterey:       "670138c44421b7111c2f3904ef193183f0e9f4e9a97b62d0a2a2f9f2b32db4f4"
    sha256 arm64_linux:    "f3f1ba40fb7ed60d1a13f4b9942c93c319d2f09e95720fd03e34175288679458"
    sha256 x86_64_linux:   "3b1e0d4c1d736021d7d4ffb1354df112cef5815b4bf5c79669639cd80a9eb401"
  end

  depends_on "libao"
  depends_on "libid3tag"
  depends_on "mad"

  # 1. Apple defines semun already. Skip redefining it to fix build errors.
  #    This is a homemade patch fashioned using deduction.
  # 2. Also a couple of IPV6 values are not defined on OSX that are needed.
  #    This patch was seen in the wild for an app called lscube:
  #       lscube.org/pipermail/lscube-commits/2009-March/000500.html [LOST LINK]
  # Both patches have been reported upstream here:
  # https://sourceforge.net/p/mpg321/patches/20/
  # Remove these at: Unknown.  These have not been merged as of 0.3.2.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/mpg321/0.3.2.patch"
    sha256 "a856292a913d3d94b3389ae7b1020d662e85bd4557d1a9d1c8ebe517978e62a1"
  end

  # Apply Gentoo patch for Clang 16
  patch do
    url "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-sound/mpg321/files/mpg321-0.3.2-clang16.patch?id=ba6b4630d2b4cc294a3057b1f4770650bcb12c87"
    sha256 "bafc5868a8293fe465449ab27bececc6039001b1519af872ecf4178afabc1a5c"
  end

  def install
    # Fix compilation with GCC 11
    ENV.append_to_cflags "-fcommon" if OS.linux?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-mpg123-symlink",
                          "--enable-ipv6",
                          "--disable-alsa"
    system "make", "install"
  end

  test do
    system bin/"mpg321", "--version"
  end
end
