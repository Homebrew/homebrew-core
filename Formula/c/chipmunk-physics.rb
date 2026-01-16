class ChipmunkPhysics < Formula
  desc "2D rigid body physics library written in C"
  # cannot resolve host bug report, https://github.com/slembcke/Chipmunk2D/issues/261
  homepage "https://github.com/slembcke/Chipmunk2D"
  url "https://chipmunk-physics.net/release/Chipmunk-7.x/Chipmunk-7.0.3.tgz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/chipmunk/Chipmunk-7.0.3.tgz"
  sha256 "048b0c9eff91c27bab8a54c65ad348cebd5a982ac56978e8f63667afbb63491a"
  license "MIT"
  head "https://github.com/slembcke/Chipmunk2D.git", branch: "master"

  livecheck do
    url "https://chipmunk-physics.net/downloads.php"
    regex(/>\s*Chipmunk2D\s+v?(\d+(?:\.\d+)+)\s*</i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "812f69a9a0065f99dd7c215c6de16629def031aff0bdb8e315e91113c9f45a7e"
    sha256 cellar: :any,                 arm64_sequoia: "be1319def436cdfea53765897ce02cb7a223df465dbac30190d605c0d8c20738"
    sha256 cellar: :any,                 arm64_sonoma:  "4523898ac36348fbfdb179e9ea830cc5eb1ab5bc23ad7d5a12b7a32dc9f4c3dd"
    sha256 cellar: :any,                 arm64_ventura: "327158f4df3225b40bf01d32424a82ff9a23395e13e403e0d02ba4bd76e04fc0"
    sha256 cellar: :any,                 sonoma:        "9afdb0a88e02dda8861e5f0e5d19b48f560ffcf85472c686e30106f9821744f6"
    sha256 cellar: :any,                 ventura:       "0ca08e1d68866462daea6c85370d6178ee49dda831b2cc692275e3bbad9efe33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a8d97795143af72a151cef0bd9456aa1dd6d3c64ca9150e23f291ea934b525f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "483b9cbddc9ae341718ffa758968de5bd458be486b2c43e871997eb95db9dd73"
  end

  depends_on "cmake" => :build

  def install
    inreplace "src/cpHastySpace.c", "#include <sys/sysctl.h>", "#include <linux/sysctl.h>" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_DEMOS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <chipmunk.h>

      int main(void){
        cpVect gravity = cpv(0, -100);
        cpSpace *space = cpSpaceNew();
        cpSpaceSetGravity(space, gravity);

        cpSpaceFree(space);
        return 0;
      }
    C
    system ENV.cc, testpath/"test.c", "-o", testpath/"test", "-pthread",
                   "-I#{include}/chipmunk", "-L#{lib}", "-lchipmunk"
    system "./test"
  end
end
