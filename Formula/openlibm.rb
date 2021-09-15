class Openlibm < Formula
  desc "High quality, portable, open source libm implementation"
  homepage "https://openlibm.org"
  url "https://github.com/JuliaMath/openlibm/archive/v0.7.5.tar.gz"
  sha256 "be983b9e1e40e696e8bbb7eb8f6376d3ca0ae675ae6d82936540385b0eeec15b"
  license all_of: ["MIT", "ISC", "BSD-2-Clause"]

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "9f5a7236623f95551f78125570bf0cfddc1e790df87f22d10fe8c65f436c0968"
    sha256 cellar: :any,                 big_sur:       "961ba50e01bfa9492d3c38e412ffdf7eab721f91eba9e6eaa659307fdc4e2d5a"
    sha256 cellar: :any,                 catalina:      "c0cde03193f6151f1b6e49a1d1af14af2b5052dffcd3b09527b6d62ad28a1193"
    sha256 cellar: :any,                 mojave:        "ab439cf5a655dc9db2ed8f05b4059f85b7ec0414d7123c2f683ab1d90dd24d55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37ebf9d3dc75b66e3e6de7ae7112b0f4210ae24a5a7a16c06a774db2d185de71"
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
