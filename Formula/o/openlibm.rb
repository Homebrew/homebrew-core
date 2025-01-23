class Openlibm < Formula
  desc "High quality, portable, open source libm implementation"
  homepage "https://openlibm.org"
  url "https://github.com/JuliaMath/openlibm/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "d380c2d871f6dc16e22893569d57bda9121742cc8f6534510526e5278867c6cf"
  license all_of: ["MIT", "ISC", "BSD-2-Clause"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ebb6a4126500ffa530262bc877e8b902549373ed7fdf260988ccb814aeeea71a"
    sha256 cellar: :any,                 arm64_sonoma:  "bc23a592bf2a7bc1997aa2dc9eed30a4aee5fdc46ded528848145aadbfa26c01"
    sha256 cellar: :any,                 arm64_ventura: "9411ef9fade3b7288f08fbbb85c0b0c5a1aba3f598a9b1ed8fd6cf32e1b8ac46"
    sha256 cellar: :any,                 sonoma:        "4a11a69b74568f64a3162246b92acbb20999a3bdca9e29aeb432de59649f7548"
    sha256 cellar: :any,                 ventura:       "f56c0d4a666c1a5d65c7fcf2a43658f39491c5269ff3530955b324e181d8d088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c35214d56a3ce8d747fe4651d941fda780c00df385d0a06698be7952459453fc"
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
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "openlibm.h"
      int main (void) {
        printf("%.1f", cos(acos(0.0)));
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}/openlibm",
           "-o", "test"
    assert_equal "0.0", shell_output("./test")
  end
end
