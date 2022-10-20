class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/videolan/libbluray/1.3.3/libbluray-1.3.3.tar.bz2"
  sha256 "58ff52cdcee64c55dcc3c777a1c39fb41abd951b927978e4d2b6811b9193a488"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.videolan.org/pub/videolan/libbluray/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d5f2c92bd6e50a0e5f5deaaac18697c188f40f772744934035188d45e3742d16"
    sha256 cellar: :any,                 arm64_big_sur:  "38f92ef02a7574639d7ba07bd749a7db01e46d1270b3b48fb2fb4d9b2b2ce459"
    sha256 cellar: :any,                 monterey:       "0d5cfd70f4b146c855f0f0149e230dc573287cfcc7d84c26ebf507a9fc7a1b46"
    sha256 cellar: :any,                 big_sur:        "dde2149e8b7da0d496e006de9c9335e085952e47a54df9c72b9921c6e800a21a"
    sha256 cellar: :any,                 catalina:       "55a591d08739fd75efdc192113e0c2a7f40785c58fd1c491592084a0c43e063d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afd7579f808ebc5d055e03cf6743167f3c525173c025c50b4f21aa9e2066fd28"
  end

  head do
    url "https://code.videolan.org/videolan/libbluray.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"

  uses_from_macos "libxml2"

  def install
    args = %W[--prefix=#{prefix} --disable-dependency-tracking --disable-silent-rules --disable-bdjava-jar]

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libbluray/bluray.h>
      int main(void) {
        BLURAY *bluray = bd_init();
        bd_close(bluray);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lbluray", "-o", "test"
    system "./test"
  end
end
