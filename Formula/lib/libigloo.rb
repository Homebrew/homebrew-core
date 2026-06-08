class Libigloo < Formula
  desc "Generic C framework used and developed by the Icecast project"
  homepage "https://icecast.org/"
  url "https://downloads.xiph.org/releases/igloo/libigloo-0.9.5.tar.gz"
  sha256 "ea22e9119f7a2188810f99100c5155c6762d4595ae213b9ac29e69b4f0b87289"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3d5f68bae027b04b01c5d655f97a468422f9c1c32fe8c82f5402665bad2d0623"
    sha256 cellar: :any,                 arm64_sequoia: "0013eb663812b10c614a73834810c5395a2ed4b7ad6796a45f26db764133313d"
    sha256 cellar: :any,                 arm64_sonoma:  "89394c808c6baf3647ae76dc42602759cb334f79c3d1c5a4f739990ad9f16fba"
    sha256 cellar: :any,                 sonoma:        "418a6e5391b2d4e9f0b11e551225bd87919213d7214cef0d9bb26bc057f99773"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "958f770928e91a64c9110fd6ac6542aedd9077b4fe113f813b32ed787545cbd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dea224d854e686dcba2b8acb544ed8da6af9a5210cbcbbd8bd75df3c00d83856"
  end

  head do
    url "https://gitlab.xiph.org/xiph/icecast-libigloo.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "rhash"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <igloo/tap.h>

      int main(void) {
        igloo_tap_init();
        igloo_tap_exit_on(igloo_TAP_EXIT_ON_FIN, NULL);
        igloo_tap_fin();
        return EXIT_FAILURE;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ligloo"
    system "./test"
  end
end
