class Openlibm < Formula
  desc "High quality, portable, open source libm implementation"
  homepage "https://openlibm.org"
  url "https://github.com/JuliaMath/openlibm/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "e328a1d59b94748b111e022bca6a9d2fc0481fb57d23c87d90f394b559d4f062"
  license all_of: ["MIT", "ISC", "BSD-2-Clause"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0f69832aa3e0b5037e36303fa31570016dd59cfc981e6a84e8a130803939e45a"
    sha256 cellar: :any,                 arm64_sequoia: "e6752fb0e310f950ac52cf3b48f1bb8bf6cfd54f232a600cab2c7193c13d21a8"
    sha256 cellar: :any,                 arm64_sonoma:  "6e7c1eb94e6db408c98f94b058f90306d92b9d507565a0896a83b40fd533cb50"
    sha256 cellar: :any,                 arm64_ventura: "f90c6264298e3fd95ac064d63e15723cae49d108b50b30bd1a080ad403040e6b"
    sha256 cellar: :any,                 sonoma:        "1d6f591d67d422a6982b28e3a59902d44bb71b24cb2133c8db0fd321f57383a8"
    sha256 cellar: :any,                 ventura:       "49ae13794c8ab5fc7de41f88ed72be8850a2cb97c1843e894c38ecebee7631e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbe1119287757ad8439a93b6cfdf94930ba7cd379e77d7f3f9ccee84043c7ee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0c35b3584719869ecc0b55090a1edd31b5df57c52b55f110cb0be30b9849d89"
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
