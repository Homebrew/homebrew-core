class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "https://www.netlib.org/lapack/"
  url "https://www.netlib.org/lapack/lapack-3.8.0.tar.gz"
  sha256 "deb22cc4a6120bff72621155a9917f485f96ef8319ac074a7afbc68aab88bcf6"
  revision 1
  head "https://github.com/Reference-LAPACK/lapack.git"

  bottle do
    sha256 "5cd0dfbb4814bbecda514adbc4a4fd900b3a29fd6bed13357c817a4669557fea" => :mojave
    sha256 "fc5162e536ab2909d5232e09c78ac5257d51c8effbb6ed586e9fa5fe98b3b7d9" => :high_sierra
    sha256 "a4257ee255778776eda1eb8b89ba27f424e99200310e277859c5df086159f58a" => :sierra
    sha256 "e11fa8f2435edc1d9e992c59c0168a24c4402d717288d721e0b2fa4f2819f899" => :el_capitan
  end

  keg_only :provided_by_macos

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran

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
