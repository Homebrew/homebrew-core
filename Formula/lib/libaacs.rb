class Libaacs < Formula
  desc "Implements the Advanced Access Content System specification"
  homepage "https://www.videolan.org/developers/libaacs.html"
  url "https://get.videolan.org/libaacs/0.11.1/libaacs-0.11.1.tar.bz2"
  mirror "https://download.videolan.org/pub/videolan/libaacs/0.11.1/libaacs-0.11.1.tar.bz2"
  sha256 "a88aa0ebe4c98a77f7aeffd92ab3ef64ac548c6b822e8248a8b926725bea0a39"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?libaacs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "bb76e9a99df6cbd2ddafd00b7d2bfec36f1d2340573402d912e25f2602d2a9af"
    sha256 cellar: :any,                 arm64_sequoia:  "ff23fb9dd6dd26f6dde8ac12c298be21546d2e3696fe7b064af1647b3788156d"
    sha256 cellar: :any,                 arm64_sonoma:   "7299a85edecb49ec7e77d70dbda59f4ef4d4879f7c7c28f01b7ccfe213675c2b"
    sha256 cellar: :any,                 arm64_ventura:  "17fb11e42e6b614543f8bdb7f79ab5ed918a5d2fac7442b9abc46c0bcbab3712"
    sha256 cellar: :any,                 arm64_monterey: "821c6fed1af02d4446d3e376bf8eda6ef671e9623ff1332b5d299a60ef1f2dbc"
    sha256 cellar: :any,                 arm64_big_sur:  "9205c7991ff5459dea68e115f5b09d95a937e06798c8ab536b07f554057c4261"
    sha256 cellar: :any,                 sonoma:         "8a98b41aa3b27875fc6bde0468647b2dfa0e5dce93e36539db11e587058e7ba4"
    sha256 cellar: :any,                 ventura:        "4f0ca503d8c661f8a4dfc42f288ee0e6238207caa4b112d86b244bb59fcbbb4e"
    sha256 cellar: :any,                 monterey:       "32d350f3eb0294166767cf9f6f4f65c48e4619a635c8450bea42330d071e74ed"
    sha256 cellar: :any,                 big_sur:        "cb432910cc4b313478eeb21e71035f82310189f54090723c9bc4167dc25ada9e"
    sha256 cellar: :any,                 catalina:       "75e631b79c6ba6115572a390dd1c2ae75653449b8bd1edc27c549745b3d03ba8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bef6e8371ad31a24f757a5b645cc6ec1c608da65e05a5da1c09a7256cc47af27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc5a1b4925f4a25d7714f9ddebdd14478d2c75d7d292153a709a412dbb3ba63d"
  end

  head do
    url "https://code.videolan.org/videolan/libaacs.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bison" => :build
  depends_on "libgcrypt"

  uses_from_macos "flex" => :build

  # Fix missing include.
  patch :DATA

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "libaacs/aacs.h"
      #include <stdio.h>

      int main() {
        int major_v = 0, minor_v = 0, micro_v = 0;

        aacs_get_version(&major_v, &minor_v, &micro_v);

        printf("%d.%d.%d", major_v, minor_v, micro_v);
        return(0);
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-laacs",
                   "-o", "test"
    system "./test"
  end
end
__END__
diff --git a/src/devtools/read_file.h b/src/devtools/read_file.h
index 953b2ef..d218417 100644
--- a/src/devtools/read_file.h
+++ b/src/devtools/read_file.h
@@ -20,6 +20,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <errno.h>
+#include <sys/types.h>

 static size_t _read_file(const char *name, off_t min_size, off_t max_size, uint8_t **pdata)
 {
