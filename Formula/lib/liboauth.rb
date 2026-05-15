class Liboauth < Formula
  desc "C library for the OAuth Core RFC 5849 standard"
  homepage "https://sourceforge.net/projects/liboauth/"
  url "https://downloads.sourceforge.net/project/liboauth/liboauth-1.0.3.tar.gz"
  sha256 "0df60157b052f0e774ade8a8bac59d6e8d4b464058cc55f9208d72e41156811f"
  # if configured with '--enable-gpl' see COPYING.GPL and LICENSE.OpenSSL
  # otherwise read COPYING.MIT
  license "MIT"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6470f165d97ff5cf41531245eb4fdd67945698303e07a574974856045845abb0"
    sha256 cellar: :any,                 arm64_sequoia: "b27df2abe1adb83de25315b4c816e960d1e1f97a9aed6a74f7d9809c069c1226"
    sha256 cellar: :any,                 arm64_sonoma:  "a3eca48a1fdd8d432880b84983cabeff3014294335a2ea7ef7e9bd25a742a6fd"
    sha256 cellar: :any,                 sonoma:        "197c5dc93bd36291e3bff2ec90953a65acf867848c96aa44deb8126cb293569f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47b23d8759b2430b614d3b78f07521d360c07b5f93a6362d999afec49d889d7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c90bf4fc3799352c6d67b1db57bc29d4cd35f13afec7eac48df218ba959ae4d"
  end

  depends_on "openssl@4"

  # Patch for compatibility with OpenSSL 1.1
  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/121e6c77a8e6b9532ce6e45c8dd8dbf38ca4f97d/net/liboauth/files/patch-src_hash.c"
    sha256 "a7b0295dab65b5fb8a5d2a9bbc3d7596b1b58b419bd101cdb14f79aa5cc78aea"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-curl"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stddef.h>
      #include <oauth.h>
      #include <stdlib.h>
      #include <string.h>

      int main(void) {
        char *escaped = oauth_url_escape("hello world!");
        int failed = !escaped || strcmp(escaped, "hello%20world%21") != 0;
        free(escaped);
        return failed;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-loauth", "-o", "test"
    system "./test"
  end
end
