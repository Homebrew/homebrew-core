class Openlibm < Formula
  desc "High quality, portable, open source libm implementation"
  homepage "https://openlibm.org"
  url "https://github.com/JuliaMath/openlibm/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "347998968cfeb2f9b91de6a8e85d2ba92dec0915d53500a4bc483e056f85b94c"
  license all_of: ["MIT", "ISC", "BSD-2-Clause"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a0dc81e93df4ac3b526f26c735c5c08da119a54209e49fc0f2a5d2bb4d82b6af"
    sha256 cellar: :any,                 arm64_sonoma:  "64d50bcefebd111f29c11bc05eb551b037fd35a7fbf28faf564a69963a153700"
    sha256 cellar: :any,                 arm64_ventura: "0830994898d6ba15c3b9185e930d38f94693cf033d1dbdcd90d02795921e8a51"
    sha256 cellar: :any,                 sonoma:        "d578955d8218e8c931a6e351119a53e3ab5038abdc616952b1ee7e6f86d31607"
    sha256 cellar: :any,                 ventura:       "2704daa0edcd8da9b5d5329354936ded7d51126b2814fe2c9f54a0da17b440cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e93592d2ad7669d07160dcd5dc74701275e0acca572e6f13dbd5b44fb19fe191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "226b4eb1ee269df454fb708a5f862f2d9e98cbc7d4a9ce0d662cc239fa37d0a8"
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
