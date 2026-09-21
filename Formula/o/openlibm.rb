class Openlibm < Formula
  desc "High quality, portable, open source libm implementation"
  homepage "https://openlibm.org"
  url "https://github.com/JuliaMath/openlibm/archive/refs/tags/v0.8.8.tar.gz"
  sha256 "721bab18ff37160fd9e903eb211ff26fdee38c3d0041d556b07d76089c435d17"
  license all_of: ["MIT", "ISC", "BSD-2-Clause"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "00ac0e24b2cebd94903caf33e0726cd32134bddd943b3412403f3b8e287bc91a"
    sha256 cellar: :any, arm64_tahoe:       "609b5d04e458eefa10f8db06a8b93c4abe876ee8165b0ed3bc4e4917be80ee9a"
    sha256 cellar: :any, arm64_sequoia:     "0af5df82bd1ba0f2aff8ab11de68706bc4c64a921625a1c5203361b332845293"
    sha256 cellar: :any, arm64_sonoma:      "31a5803f82f0f0d07f241d39834e640dc0440bfececc0d58fe00ac45c9cd7d6c"
    sha256 cellar: :any, arm64_linux:       "0dfb4f0544a19cbbfcf1f29fba79ee6103cd393810da14048188cf47ab075da2"
    sha256 cellar: :any, x86_64_linux:      "4924638ac4d74c1e4717d843e6132ac4b37f3a88fcf99f9a5c2f79946b89e5b7"
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
