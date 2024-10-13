class Libsolv < Formula
  desc "Library for solving packages and reading repositories"
  homepage "https://github.com/openSUSE/libsolv"
  url "https://github.com/openSUSE/libsolv/archive/refs/tags/0.7.30.tar.gz"
  sha256 "ce4aa2f0e3c5c9ab99dced6a1810af3f670f1b98892394edc68ccabe7b272133"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e3a12d98ef2e158258a036af17e4c1b06ee7b3516a521e609c803a62622bf5b4"
    sha256 cellar: :any,                 arm64_sonoma:   "67fdecdc409d7985f97f9d0ec835e838b8a2a22c693e6650da379c623378c03a"
    sha256 cellar: :any,                 arm64_ventura:  "e5550b95ded578e6456629bec5050a9a2ff730f3833b55b5f57ddc08f5858160"
    sha256 cellar: :any,                 arm64_monterey: "605dba92ff28fb99043729da1792d2ed32acb5e6feb52ae2ab898115fe03a095"
    sha256 cellar: :any,                 sonoma:         "e293ec024d26136dbaafc8b7b560db4a9679abb2285eb9bc3f4066eb9def9164"
    sha256 cellar: :any,                 ventura:        "5a3c2423ec901cd464962e494cf801aed80abfe0e7d0195bbadc0772210ea84e"
    sha256 cellar: :any,                 monterey:       "b00ed6d6773f1c0aeedd92943baa137423fe9e21aaa1ca771d81fa1e56ebe25d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b81f94d7990b8a3adb421f744319b2d947725f7e861fac7fefe3da3d74744c9c"
  end

  depends_on "cmake" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    args = %W[
      -DENABLE_STATIC=ON
      -DENABLE_SUSEREPO=ON
      -DENABLE_COMPS=ON
      -DENABLE_HELIXREPO=ON
      -DENABLE_DEBIAN=ON
      -DENABLE_MDKREPO=ON
      -DENABLE_ARCHREPO=ON
      -DENABLE_CUDFREPO=ON
      -DENABLE_CONDA=ON
      -DENABLE_APPDATA=ON
      -DMULTI_SEMANTICS=ON
      -DENABLE_LZMA_COMPRESSION=ON
      -DENABLE_BZIP2_COMPRESSION=ON
      -DENABLE_ZSTD_COMPRESSION=ON
      -DENABLE_ZCHUNK_COMPRESSION=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <solv/pool.h>
      #include <solv/repo.h>

      int main(int argc, char **argv) {
        Pool *pool = pool_create();

        Repo *repo = repo_create(pool, "test");

        pool_free(pool);
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lsolv", "-o", "test"
    system "./test"
  end
end
