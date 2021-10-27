class Openlibm < Formula
  desc "High quality, portable, open source libm implementation"
  homepage "https://openlibm.org"
  url "https://github.com/JuliaMath/openlibm/archive/v0.8.0.tar.gz"
  sha256 "03620768df4ca526a63dd675c6de95a5c9d167ff59555ce57a61c6bf49e400ee"
  license all_of: ["MIT", "ISC", "BSD-2-Clause"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "52326d43b4a9abba843ae96ca89e20837d5c9d07b294d8e51c08e97deb0cb59a"
    sha256 cellar: :any,                 arm64_big_sur:  "7888ae22fd737d90f51fa2626c06352b93508bd6e7774a5c6c96f8d92eef0b8d"
    sha256 cellar: :any,                 monterey:       "0493040cbfc0dca4765d671ba06ec3f2316f373e9b42e1eba2988e3a1e5fa2bc"
    sha256 cellar: :any,                 big_sur:        "99bb06b44d697d843daf534205d825d4e6bc249b4d31784d3af067db01ed08df"
    sha256 cellar: :any,                 catalina:       "63471db2953d8531ca5c2635763113d05a277a9ed6e6e8b2df4a03a45a2404eb"
    sha256 cellar: :any,                 mojave:         "b3158fe12cbff247013753f4fe342822ff93c7d7f5c5c2c5baf1dc5a3cfae8a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cb7cb86a325830476a7434c87728d4755b0404afade42c9fb390bf20610cca5"
  end

  def install
    lib.mkpath
    (lib/"pkgconfig").mkpath
    (include/"openlibm").mkpath

    system "make", "install", "prefix=#{prefix}"

    lib.install Dir["lib/*"].reject { |f| File.directory? f }
    (lib/"pkgconfig").install Dir["lib/pkgconfig/*"]
    (include/"openlibm").install Dir["include/openlibm/*"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "openlibm.h"
      int main (void) {
        printf("%.1f", cos(acos(0.0)));
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}/openlibm",
           "-o", "test"
    assert_equal "0.0", shell_output("./test")
  end
end
