class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/2.0.0/libjpeg-turbo-2.0.0.tar.gz"
  sha256 "778876105d0d316203c928fd2a0374c8c01f755d0a00b12a1c8934aeccff8868"

  bottle do
    sha256 "3419adae8718b8b9fc41cd7e7f74803bdc4437d2f754605a59e8768d2630512f" => :high_sierra
    sha256 "68d14fd1b5a59c349e9bdd639d25841947f790f48d3eb788898599bb62515560" => :sierra
    sha256 "5782250ca2948367083ccd42aacba569efe888bd5a2727faa01d6ad6234d02ab" => :el_capitan
  end

  head do
    url "https://github.com/libjpeg-turbo/libjpeg-turbo.git"

    depends_on "cmake" => :build
  end

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg"

  option "without-test", "Skip build-time checks (Not Recommended)"

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  def install
    system "cmake", ".", "-DWITH_JPEG8=1", *std_cmake_args
    system "make"
    system "make", "test" if build.with? "test"
    system "make", "install"
  end

  test do
    system "#{bin}/jpegtran", "-crop", "1x1", "-transpose", "-perfect",
                              "-outfile", "out.jpg", test_fixtures("test.jpg")
  end
end
