class Libsolv < Formula
  desc "Library for solving packages and reading repositories"
  homepage "https://github.com/openSUSE/libsolv"
  url "https://github.com/openSUSE/libsolv/archive/refs/tags/0.7.35.tar.gz"
  sha256 "e6ef552846f908beb3bbf6ca718b6dd431bd8a281086d82af9a6d2a3ba919be5"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b1d4aadeb9b8572bf351d0c07806f964666efa0cd12c3573ff6c96e8540a4ba1"
    sha256 cellar: :any,                 arm64_sequoia: "ae33d25d26ff710352a06a38a421fd0216c30eb55827e0ce5681912aa91459a0"
    sha256 cellar: :any,                 arm64_sonoma:  "3a55a375e654f3ddfb7e6f4f5cfa981a69de84fc08ab44a3e0baf5f39e4580bc"
    sha256 cellar: :any,                 sonoma:        "fdb5677bef312a9dd7a2209dfed282cf68cbdaa3274ec023a2f5c28aecf02000"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbb660601132e01fb609156195711da39e07a7a825aaec07b0e5791c8a9163b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1561ca87a5a76167c49b46f6682c99cf46ea90bfd20262ad7aa78067790636aa"
  end

  depends_on "cmake" => :build
  depends_on "rpm"
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
      -DENABLE_RPMDB=ON
      -DENABLE_RPMMD=ON
      -DENABLE_RPMPKG=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <solv/pool.h>
      #include <solv/repo.h>

      int main(int argc, char **argv) {
        Pool *pool = pool_create();

        Repo *repo = repo_create(pool, "test");

        pool_free(pool);
      }
    CPP
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lsolv", "-o", "test"
    system "./test"
  end
end
