class Openlibm < Formula
  desc "High quality, portable, open source libm implementation"
  homepage "https://openlibm.org"
  url "https://github.com/JuliaMath/openlibm/archive/v0.8.1.tar.gz"
  sha256 "ba8a282ecd92d0033f5656bb20dfc6ea3fb83f90ba69291ac8f7beba42dcffcf"
  license all_of: ["MIT", "ISC", "BSD-2-Clause"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e2ff5bc492cd9e69a9a9730e9b5890017dece0b65b565686391687d078e275a8"
    sha256 cellar: :any,                 arm64_monterey: "9b05e09f90c7be45091bb34aa339fdd8ae36e9de8463ba0844bc13940a9c71f4"
    sha256 cellar: :any,                 arm64_big_sur:  "724ef933bb44a0bd8f884ccbb4bb2013b2b89af4cd1def67a411ae914ef622fd"
    sha256 cellar: :any,                 ventura:        "6cf9238a296315347533753f4eb1125a71bf4689968deb5c59b7843b74d39b24"
    sha256 cellar: :any,                 monterey:       "821bb85640df061c0a49c079e06e7f932916c2b47bca228f61b3ed1401f17370"
    sha256 cellar: :any,                 big_sur:        "fbaaaaee44ecd462b9b9cf94ebcf386bca16591b6a4be7985e479db98f18f280"
    sha256 cellar: :any,                 catalina:       "7726b400040c12f35eb13cb88dd80444d09f82dce79ef9825b0fc864952f6c39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9024f7a8469743a4ca9d4b13aa27254367ba4285447a6668f04da94b7d7971f0"
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
