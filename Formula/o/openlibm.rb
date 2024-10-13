class Openlibm < Formula
  desc "High quality, portable, open source libm implementation"
  homepage "https://openlibm.org"
  url "https://github.com/JuliaMath/openlibm/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "9f83e40d1180799e580371691be522f245da4c2fdae3f09cd33031706de4c59c"
  license all_of: ["MIT", "ISC", "BSD-2-Clause"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "13cc1cf68e2ce18150fff0ba1a0bdca26b114f9ccd305b2fe37390a0d43605ae"
    sha256 cellar: :any,                 arm64_sonoma:   "ea138b154ee285ea9e7dfc8e75095f5ef10b35e26a385cddb29be717e0845830"
    sha256 cellar: :any,                 arm64_ventura:  "6c26c17ebbbfa29ba9b240368f553f116a13ac5aa56776ebb648f405f3ed9058"
    sha256 cellar: :any,                 arm64_monterey: "643421ea8cf4fe60d165534daaba6a9028c85c336a196f4a8b7075a1d5053050"
    sha256 cellar: :any,                 sonoma:         "d43a797126c456158cfd2916be3c59999dd947389ec3f0f3568d26fb236e3040"
    sha256 cellar: :any,                 ventura:        "6429d3667b4a15a182f21f497914062f36ff63ac0e7bb85c6a47819fec2b234e"
    sha256 cellar: :any,                 monterey:       "fbfa7f78bd9e7f46ff19f4b9b5b645a365bb9d488e7a76ef31ef5ba867b1ae01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85ab572e3a32c552acf1b0f628dd36c82843ed89227b0123fa1b75affd37fd19"
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
