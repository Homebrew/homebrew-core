class EbookTools < Formula
  desc "Access and convert several ebook formats"
  homepage "https://sourceforge.net/projects/ebook-tools/"
  url "https://downloads.sourceforge.net/project/ebook-tools/ebook-tools/0.2.2/ebook-tools-0.2.2.tar.gz"
  sha256 "cbc35996e911144fa62925366ad6a6212d6af2588f1e39075954973bbee627ae"
  license "MIT"
  revision 4

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9cac7c5b835702327a836ed085a05cf2e7198af37bbc0d1e5704b2c587e68d3c"
    sha256 cellar: :any,                 arm64_sequoia: "71206983efece5f146c2ec3e0df4f41afa0a3d9332fd52ca9050f1dfd998e48a"
    sha256 cellar: :any,                 arm64_sonoma:  "423897ffb33e0eb1247e569e55c259efeb890e64920dff86c3b47513a2112181"
    sha256 cellar: :any,                 sonoma:        "7c03d72508b1532ae32b8d26f87025c2c996d6c417b647aa14afd9e262fbdf5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dbbf61c1175f6e76f2ba46505be967e5755e1dd76c86c7a139d52c66bc6ddd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "285e12884578f5fa3e1b110a83544034a540ba806b62b991dbe86b9115cb53c4"
  end

  depends_on "cmake" => :build
  depends_on "libzip"

  uses_from_macos "libxml2"

  def install
    # Workaround to build with CMake 4
    args = %W[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"einfo", "-help"

    (testpath/"test_libepub.c").write <<~C
      #include <stdio.h>
      #include "epub_version.h"

      int main() {
          printf("libepub version: %s\\n", LIBEPUB_VERSION_STRING);
          return 0;
      }
    C

    system ENV.cc, "test_libepub.c", "-I#{include}", "-L#{lib}", "-lepub", "-o", "test_libepub"
    system "./test_libepub"
  end
end
