class Libmpeg2 < Formula
  desc "Library to decode mpeg-2 and mpeg-1 video streams"
  homepage "https://libmpeg2.sourceforge.io/"
  url "https://download.videolan.org/contrib/libmpeg2/libmpeg2-0.5.1.tar.gz"
  mirror "https://libmpeg2.sourceforge.io/files/libmpeg2-0.5.1.tar.gz"
  sha256 "dee22e893cb5fc2b2b6ebd60b88478ab8556cb3b93f9a0d7ce8f3b61851871d4"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://libmpeg2.sourceforge.io/downloads.html"
    regex(/href=.*?libmpeg2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "d62eb9cd43b94dcf7a1d4541a2be2e97648406beb993217d36ce32e4c7982e39"
    sha256 cellar: :any, arm64_sequoia: "c97f23520800dc78b5e7cce85248756223f4710db7668405562b6ef0b4a38cbf"
    sha256 cellar: :any, arm64_sonoma:  "cb8c3561c4a446fe308cd04b95270872cf3068c119d1dfa6874b8b386d0385f3"
    sha256 cellar: :any, sonoma:        "21e8bc63e7b98bbdd12231e6544560c0b5067d40f9610a635ea000dc23e2f7f8"
    sha256 cellar: :any, arm64_linux:   "0c75d7a0837586a34d08a42d6802ab58ca456b47d0cfce47bbc33d0ac1a18b5e"
    sha256 cellar: :any, x86_64_linux:  "91162a4ef667f5b1d34cfa72aeeedd4f14d1035117d3f0faf9cf79e753046c30"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_linux do
    depends_on "libx11"
    depends_on "libxext"
  end

  def install
    # Otherwise compilation fails in clang with `duplicate symbol ___sputc`
    ENV.append "CFLAGS", "-std=gnu89"

    system "autoreconf", "--force", "--install", "--verbose"
    # Build without old SDL 1.2 similar to Debian and Arch Linux
    system "./configure", "--disable-sdl", *std_configure_args
    system "make", "install"
    pkgshare.install "doc/sample1.c"
  end

  test do
    system ENV.cc, "-I#{include}/mpeg2dec", pkgshare/"sample1.c", "-L#{lib}", "-lmpeg2"
  end
end
