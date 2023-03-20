class Libsolv < Formula
  desc "Library for solving packages and reading repositories"
  homepage "https://github.com/openSUSE/libsolv"
  url "https://github.com/openSUSE/libsolv/archive/refs/tags/0.7.23.tar.gz"
  sha256 "0286155964373c6cc3802d025750786c3ee79608d5cb884598e110e3918bb2fe"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f48d9544a317cb66ffce9d2b31b16f8e5b467859fdbc29254557efd87abe2c13"
    sha256 cellar: :any,                 arm64_monterey: "a52ed60a8dc9907672a1d3dbd2ecce9a2ced03237e664e85e97c44371c1e8c30"
    sha256 cellar: :any,                 arm64_big_sur:  "84e605e61a32b4dee8d3ceb10066415c00f36abc6f050025919ba8c17ba7771c"
    sha256 cellar: :any,                 ventura:        "e836a6d1bee9148cf85916cf8a0b392334a459915ea3617fae242f49dd21aec0"
    sha256 cellar: :any,                 monterey:       "d622fd7478b2ebe090a614224167c18269a520997499da4f786d1c90d485f2ca"
    sha256 cellar: :any,                 big_sur:        "b94ec4999f1b7b6292de66414111706d9e658f48bcf5ab44aa68657660668b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42d5bced4e97cb13c26bbb3d614beb72173088d5345e1509551cf5cb9103cbc6"
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
