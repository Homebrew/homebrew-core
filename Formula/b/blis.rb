class Blis < Formula
  desc "BLAS-like Library Instantiation Software Framework"
  homepage "https://github.com/flame/blis"
  url "https://github.com/flame/blis/archive/refs/tags/2.0.tar.gz"
  sha256 "08bbebd77914a6d1a43874ae5ec2f54fe6a77cba745f2532df28361b0f1ad1b3"
  license "BSD-3-Clause"
  head "https://github.com/flame/blis.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eaa5b7da801e3b1915288ce0938b19d5add45ba87ce3dab1277e2beb78d77654"
    sha256 cellar: :any,                 arm64_sonoma:  "ffd36f20fb15992d43255e6cd4ef2180d7415d54504d4793f9355e365e9bbc28"
    sha256 cellar: :any,                 arm64_ventura: "90e2dad3813b09a2782a32a20555d5e2a9f046040bbcbda52f53ce6962a9b25d"
    sha256 cellar: :any,                 sonoma:        "2164b835421ca2348ea9345fb673e48f97590f763fba9067ce10a181d42e661a"
    sha256 cellar: :any,                 ventura:       "d8f4e5be9a956ac208b0aa9abde47dabac3968e194b008b1b5816cca934c538a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e26aed017b11935a26a0390a2ce77619d9886ff9c760db40509f3ae106390dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dca702952b8f726f414761a5714ba34a5ba69df4e4f1e5e94a45a2d55aaa023a"
  end

  uses_from_macos "python" => :build

  def install
    # https://github.com/flame/blis/blob/master/docs/ConfigurationHowTo.md
    ENV.runtime_cpu_detection
    config = if !build.bottle?
      "auto"
    elsif OS.mac?
      # For Apple Silicon, we can optimize using the dedicated "firestorm" config.
      # For Intel Macs, we build multiple Intel x86_64 to allow runtime optimization.
      Hardware::CPU.arm? ? "firestorm" : "intel64"
    else
      # For x86_64 Linux, we build full "x86_64" family with Intel and AMD processors.
      Hardware::CPU.arch
    end

    system "./configure", "--prefix=#{prefix}", "--enable-cblas", config
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <math.h>
      #include "blis/blis.h"

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
    C
    system ENV.cc, "-o", "test", "test.c", "-I#{include}", "-L#{lib}", "-lblis", "-lm"
    system "./test"
  end
end
