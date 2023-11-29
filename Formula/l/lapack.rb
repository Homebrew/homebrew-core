class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "https://www.netlib.org/lapack/"
  url "https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "eac9570f8e0ad6f30ce4b963f4f033f0f643e7c3912fc9ee6cd99120675ad48b"
  license "BSD-3-Clause"
  head "https://github.com/Reference-LAPACK/lapack.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "0ae820c59f6c84b46a6682622fab86441a63656fcc637a10705e2a26cce2ea73"
    sha256                               arm64_ventura:  "f8a3a11925ffd4de7440b8c86426e696e85d7c6da8217f21e998caee251eda99"
    sha256                               arm64_monterey: "cda47755b619b51d24ebdb7af9f557194b223bad97c5ce6cc37714c416dc0d82"
    sha256 cellar: :any,                 sonoma:         "db676f5cd8ef89ba92a07d8a181e7bb8c52fcc9f5bc638c56854f4d7d6b1d4ca"
    sha256 cellar: :any,                 ventura:        "968c1f5c35e9ae460c15c63880301a0d615362856726f60e7640ec99406c75a7"
    sha256 cellar: :any,                 monterey:       "2dcb650157f87c0d852fb2a0b8b814fb4fd2824f45b38b7cbbbf14a6ba837273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7b417d1eacb90be49cabc625f20fffc97cfc23f20850ae5045ec43275ec237f"
  end

  keg_only :shadowed_by_macos, "macOS provides LAPACK in Accelerate.framework"

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran

  on_linux do
    keg_only "it conflicts with openblas"
  end

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
    (testpath/"lp.c").write <<~EOS
      #include "lapacke.h"
      int main() {
        void *p = LAPACKE_malloc(sizeof(char)*100);
        if (p) {
          LAPACKE_free(p);
        }
        return 0;
      }
    EOS
    system ENV.cc, "lp.c", "-I#{include}", "-L#{lib}", "-llapacke", "-o", "lp"
    system "./lp"
  end
end
