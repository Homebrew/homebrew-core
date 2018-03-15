class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "http://www.netlib.org/lapack/"
  url "http://www.netlib.org/lapack/lapack-3.8.0.tar.gz"
  sha256 "deb22cc4a6120bff72621155a9917f485f96ef8319ac074a7afbc68aab88bcf6"
  head "https://github.com/Reference-LAPACK/lapack.git"

  bottle do
    rebuild 1
    sha256 "707e8bb6197d1e6ed3633690a7b2ec3cff82272c8d83ecb17c8da2dc2a5efb3d" => :high_sierra
    sha256 "4692164cd2b121ac3f609946dbc27b8578c8519c5b6cf1b321c540eb77041a86" => :sierra
    sha256 "5eae00a6afe33f3114e33e9275dbda82182f5131c93639576367bcd44031c8ee" => :el_capitan
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
