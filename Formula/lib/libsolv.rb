class Libsolv < Formula
  desc "Library for solving packages and reading repositories"
  homepage "https://github.com/openSUSE/libsolv"
  url "https://github.com/openSUSE/libsolv/archive/refs/tags/0.7.34.tar.gz"
  sha256 "fd9c8a75d3ca09d9ff7b0d160902fac789b3ce6f9fb5b46a7647895f9d3eaf05"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "705aee3e699df7f17fca2f26ca5e9b2764c5d09850608589ce874b223115efde"
    sha256 cellar: :any,                 arm64_sonoma:  "d05cd3b8bdfbe1fc9a492cc983e283270e1e7d0c76cfa320b8207da0543bc196"
    sha256 cellar: :any,                 arm64_ventura: "95e6c45b9b3d7ce2dcd8d67adde1c2f7026540c4f40cd41b3ca53e6290314ff4"
    sha256 cellar: :any,                 sonoma:        "76be0cf755aeb56c3d93905b113fb9a98abaf21b23d35ede2982de897a901634"
    sha256 cellar: :any,                 ventura:       "6888356ca5dc9c9138de54ceb23f5e982faef135f847569a42340e07ad78d0d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d613a1b3680a9ec36c0a017c8a4e3b534399250d79bf1521c9bd7e38c168154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e0b9a3c13a9645e7eac79fb19e3160d905ff1e4aa179ecf9f93bee927171893"
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
