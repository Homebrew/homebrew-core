class Chipmunk < Formula
  desc "2D rigid body physics library written in C"
  homepage "https://chipmunk-physics.net/"
  url "https://chipmunk-physics.net/release/Chipmunk-7.x/Chipmunk-7.0.3.tgz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/chipmunk/Chipmunk-7.0.3.tgz"
  sha256 "048b0c9eff91c27bab8a54c65ad348cebd5a982ac56978e8f63667afbb63491a"
  head "https://github.com/slembcke/Chipmunk2D.git"

  bottle do
    cellar :any
    sha256 "b71191c2c1e4859cb9d5e77b8684612dec1c191780a0b1d56afc04ada66da036" => :catalina
    sha256 "16292e5518bae60c6990a6f1565e1416f91ffe1c878ab43b58465bb2a24d3d11" => :mojave
    sha256 "5370b9d8db489d6b8944c23fd4906768c84d87e22f054ca3381c7ee527233f4d" => :high_sierra
    sha256 "c92a9c1134a272244ca3936b2c94431df7ed7002a9eec99f6914fe1128adae12" => :sierra
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
