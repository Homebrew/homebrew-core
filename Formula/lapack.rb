class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "http://www.netlib.org/lapack/"
  url "http://www.netlib.org/lapack/lapack-3.8.0.tar.gz"
  sha256 "deb22cc4a6120bff72621155a9917f485f96ef8319ac074a7afbc68aab88bcf6"
  head "https://github.com/Reference-LAPACK/lapack.git"

  bottle do
    rebuild 1
    sha256 "2cb568199916473dbbc3af88a989eb2aa83a0affb02a2f1de28d0e00833a3617" => :high_sierra
    sha256 "ec2f08b08f7d3523ff19e65d4e1def00a0751150c067685361c02345e561677b" => :sierra
    sha256 "dbded2fffb6726a4617731c657954f5ec45701d271214dc3d8f18ba6f04e0692" => :el_capitan
    sha256 "2eb8751ebafdf3fda1f6e79754f662015750e1889ac063d0a79e1cf375296cba" => :yosemite
  end

  keg_only :provided_by_osx

  depends_on "cmake" => :build
  depends_on :fortran
  depends_on "gcc"

  def install
    ENV.delete("MACOSX_DEPLOYMENT_TARGET")

    mkdir "build" do
      system "cmake", "..",
                      "-DBUILD_SHARED_LIBS:BOOL=ON",
                      "-DLAPACKE:BOOL=ON",
                      *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"lp.cpp").write <<~EOS
      #include "lapacke.h"
      int main() {
        void *p = LAPACKE_malloc(sizeof(char)*100);
        if (p) {
          LAPACKE_free(p);
        }
        return 0;
      }
    EOS
    system ENV.cc, "lp.cpp", "-I#{include}", "-L#{lib}", "-llapacke", "-o", "lp"
    system "./lp"
  end
end
