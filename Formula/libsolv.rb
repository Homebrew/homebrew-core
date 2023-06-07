class Libsolv < Formula
  desc "Library for solving packages and reading repositories"
  homepage "https://github.com/openSUSE/libsolv"
  url "https://github.com/openSUSE/libsolv/archive/refs/tags/0.7.24.tar.gz"
  sha256 "62743265222a729c7fe94c40f7b90ccc1ac5568f5ee6df46884e7ce3c16c78c7"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b1679237851a718cafccc0d3b370ee2d6765c8c760c3d99937919b651646fedf"
    sha256 cellar: :any,                 arm64_monterey: "49fc4d0090609edb8c9d2c6a5240ced923bed07b2fc30b00f2d391009f3fc51b"
    sha256 cellar: :any,                 arm64_big_sur:  "9c6bb275b3a89931f35402651f1bfb6c28cc75886dd0d2b3165f2c5b113ba9cf"
    sha256 cellar: :any,                 ventura:        "79a48920dd89808d8494da3d4f58c6aaaeb7fc08b5075b15bb02af04d1e73fc4"
    sha256 cellar: :any,                 monterey:       "2f34464dbfc78d9fa25c5b4a884be9c86672e6123dad19e541213297cbb5f3f3"
    sha256 cellar: :any,                 big_sur:        "2ecefe667657bbc48d9edf7c4bca1138829ce9766128c991dafb226560302910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f42eee624b7ce9c2ff47d2f7f0478abd6d6f42733198dc03227ef5f63096658"
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
