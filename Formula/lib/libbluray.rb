class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/videolan/libbluray/1.3.4/libbluray-1.3.4.tar.bz2"
  sha256 "478ffd68a0f5dde8ef6ca989b7f035b5a0a22c599142e5cd3ff7b03bbebe5f2b"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.videolan.org/pub/videolan/libbluray/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "82b771563b1348e8121ceb5156d5457207147e8ac851aea9d70d31c058f8a98e"
    sha256 cellar: :any,                 arm64_sonoma:   "385b5460b56cb7c811c661a39509c62436d7a60f388bd960782f23192ade074a"
    sha256 cellar: :any,                 arm64_ventura:  "c51fc3248e75d1cf23f9d3d2856d719e6298b913e4b161f066993b2485a79b66"
    sha256 cellar: :any,                 arm64_monterey: "3369218f1258be668eca6975f82ac25b8a906e984d8a8344e9ed4d93657debfc"
    sha256 cellar: :any,                 arm64_big_sur:  "b321152d681e4fcd8c7fe06dfbc6f5f2f66460b19bef0faffff975fcd98b791f"
    sha256 cellar: :any,                 sonoma:         "252cb3fcb309c45ef22d9c297f5c2dc3978407eca32fa332d55e60d2051671a4"
    sha256 cellar: :any,                 ventura:        "4f07968528f3799faa411a4fc304bb762a4b2d90eda3d0292dc322fcdbeadccf"
    sha256 cellar: :any,                 monterey:       "675911bf2b50a1f33112fb2fb76acf33c03d56d465477439c34c54088eda848e"
    sha256 cellar: :any,                 big_sur:        "18490d577635a9975be2e1f06efaa5d7b33fc238af966d3587758f3a13ceb6bf"
    sha256 cellar: :any,                 catalina:       "ea15b923a467441fd884d25c339e12a5cdd6a71b39d670b301456af6428fcd0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fbf92a392c04e7ea08208af7eace86c7e320256ee4227762fab7208c3d37e2da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5777913be5f68fb71aa0e5ed057ced402b9f8ab119a8ea74623bca2b5475f04"
  end

  head do
    url "https://code.videolan.org/videolan/libbluray.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "fontconfig"
  depends_on "freetype"

  uses_from_macos "libxml2"

  def install
    args = %w[--disable-silent-rules --disable-bdjava-jar]

    system "./bootstrap" if build.head?
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libbluray/bluray.h>
      int main(void) {
        BLURAY *bluray = bd_init();
        bd_close(bluray);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lbluray", "-o", "test"
    system "./test"
  end
end
