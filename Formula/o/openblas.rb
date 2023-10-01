class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.3.24.tar.gz"
  sha256 "ceadc5065da97bd92404cac7254da66cc6eb192679cf1002098688978d4d5132"
  license "BSD-3-Clause"
  head "https://github.com/xianyi/OpenBLAS.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "14a69b61ba6db7000d23ff92cf4d1939552b8c33ea96945b187496a72afdcddf"
    sha256 cellar: :any,                 arm64_ventura:  "5a6b8d2e10942011646cc64e19aa4c04444c4f521cccf7526a2f356520aaf3cd"
    sha256 cellar: :any,                 arm64_monterey: "df4831fa56d2efec2cd36cd71d60293bb1661f7e2eb7c1ddb24c833609973d27"
    sha256 cellar: :any,                 arm64_big_sur:  "7b7cb96ea76972f420604f8b60f2026f18823d5b0d7f72aa75c8332dc6496101"
    sha256 cellar: :any,                 sonoma:         "fa3f40f9d5f8a7240820db4982bbb058ee459f1d80e6166e75e81d69654907af"
    sha256 cellar: :any,                 ventura:        "70d123d74ef2cf47a313882b1cda4dba35cc16cb0b520cf9ee6415579ae8dbed"
    sha256 cellar: :any,                 monterey:       "5ad17cd7f820015c4be5aea45051b63de1b8313d7afab842ac0cf5344b8f7f0a"
    sha256 cellar: :any,                 big_sur:        "8db45e21713c1f461eafb2e5753793edad12491ba12f1cebc7012f9463a1f0a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15d267b68507989474e0283a9a6c259fa6de412a698e1b9124f0e2cc1521db77"
  end

  keg_only :shadowed_by_macos, "macOS provides BLAS in Accelerate.framework"

  depends_on "gcc" # for gfortran
  fails_with :clang

  def install
    ENV.runtime_cpu_detection
    ENV.deparallelize # build is parallel by default, but setting -j confuses it

    # The build log has many warnings of macOS build version mismatches.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s
    ENV["DYNAMIC_ARCH"] = "1"
    ENV["USE_OPENMP"] = "1"
    # Force a large NUM_THREADS to support larger Macs than the VMs that build the bottles
    ENV["NUM_THREADS"] = "56"
    ENV["TARGET"] = case Hardware.oldest_cpu
    when :arm_vortex_tempest
      "VORTEX"
    else
      Hardware.oldest_cpu.upcase.to_s
    end

    # Apple Silicon does not support SVE
    # https://github.com/xianyi/OpenBLAS/issues/4212
    ENV["NO_SVE"] = "1" if Hardware::CPU.arm?

    # Must call in two steps
    system "make", "CC=#{ENV.cc}", "FC=gfortran", "libs", "netlib", "shared"
    system "make", "PREFIX=#{prefix}", "install"

    lib.install_symlink shared_library("libopenblas") => shared_library("libblas")
    lib.install_symlink shared_library("libopenblas") => shared_library("liblapack")
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <math.h>
      #include "cblas.h"

      int main(void) {
        int i;
        double A[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double B[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double C[9] = {.5, .5, .5, .5, .5, .5, .5, .5, .5};
        cblas_dgemm(CblasColMajor, CblasNoTrans, CblasTrans,
                    3, 3, 2, 1, A, 3, B, 3, 2, C, 3);
        for (i = 0; i < 9; i++)
          printf("%lf ", C[i]);
        printf("\\n");
        if (fabs(C[0]-11) > 1.e-5) abort();
        if (fabs(C[4]-21) > 1.e-5) abort();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lopenblas",
                   "-o", "test"
    system "./test"
  end
end
