class Libsolv < Formula
  desc "Library for solving packages and reading repositories"
  homepage "https://github.com/openSUSE/libsolv"
  url "https://github.com/openSUSE/libsolv/archive/refs/tags/0.7.36.tar.gz"
  sha256 "32b8a565b70b6ba81d9ad68070de4561dfc8462be12288725a267a90423c0fa6"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "87086273dce26bc433877f410f39ca4d3cf250fa8b257c4b36fc47243b3ecf78"
    sha256 cellar: :any,                 arm64_sequoia: "e82122f9978d6b918f9188d0b4acd3e8aa31cd403863614ba63561e58db2de9a"
    sha256 cellar: :any,                 arm64_sonoma:  "f44a274210d5f2e0f6d125d51d4e102e1a2b044e2aaba4df2f1b06195bc83a9f"
    sha256 cellar: :any,                 sonoma:        "f35a7b2bfb6ee65e76ce62c6a2d2b6f06f0bcd97835275b15dd3140e0a893b6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6881cb23d0096ba56eaf6a7f9d1e8721a8196dff7a79ba61c6ab33700ea683d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65acf2b26ea4359dfbf41daae79a079119be8926cdeffa304754db3bfa68c5f4"
  end

  depends_on "cmake" => :build
  depends_on "rpm"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
