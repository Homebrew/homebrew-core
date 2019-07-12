class Chipmunk < Formula
  desc "2D rigid body physics library written in C"
  homepage "https://chipmunk-physics.net/"
  url "https://chipmunk-physics.net/release/Chipmunk-7.x/Chipmunk-7.0.3.tgz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/chipmunk/Chipmunk-7.0.3.tgz"
  sha256 "048b0c9eff91c27bab8a54c65ad348cebd5a982ac56978e8f63667afbb63491a"
  head "https://github.com/slembcke/Chipmunk2D.git"

  bottle do
    cellar :any
    sha256 "a01faa519baf4dda632dae3a4d00e7e2833298ef03f5ebc3d96b605ebf9f6a53" => :mojave
    sha256 "9ea9773afde1b99b00d08aa462562175e0c42c961027d5d2f0e84d51565f6609" => :high_sierra
    sha256 "11d92de45ec0fa8a25872f5ac18c92e3d1686c1d515d05d48731d19f5d3c30b3" => :sierra
    sha256 "8848acb3fa314fad434f5eb143788831544453598d047342fe20c99045225d26" => :el_capitan
    sha256 "58cc2257eb17a9d67fee0c9bb8350f88a3092f149f74deba3aba591c47ae9c00" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_DEMOS=OFF", *std_cmake_args
    system "make", "install"

    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <chipmunk.h>

      int main(void){
        cpVect gravity = cpv(0, -100);
        cpSpace *space = cpSpaceNew();
        cpSpaceSetGravity(space, gravity);

        cpSpaceFree(space);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/chipmunk", "-L#{lib}", "-lchipmunk",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
