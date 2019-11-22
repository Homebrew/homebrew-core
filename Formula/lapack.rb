class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "https://www.netlib.org/lapack/"
  url "https://www.netlib.org/lapack/lapack-3.8.0.tar.gz"
  sha256 "deb22cc4a6120bff72621155a9917f485f96ef8319ac074a7afbc68aab88bcf6"
  revision 2
  head "https://github.com/Reference-LAPACK/lapack.git"

  bottle do
    sha256 "9e57f69368a3fb7c750e55bb3770253ac0da38552bdc42ba6ed127cefb8b166a" => :catalina
    sha256 "fa78953406938636ce45034e192d7611db5f72fbe46a934a2b4072ab2bb3a289" => :mojave
    sha256 "7de1e297afb68bcbcf867b5b996934e5f5d2278bbf28e95ea8c953cb3f74b0f7" => :high_sierra
    sha256 "76c5a310ea6e8a78650ab8518a57745b2aac13a93d31a95b66f23181c63c2a24" => :sierra
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
