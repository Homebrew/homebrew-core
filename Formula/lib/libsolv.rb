class Libsolv < Formula
  desc "Library for solving packages and reading repositories"
  homepage "https://github.com/openSUSE/libsolv"
  url "https://github.com/openSUSE/libsolv/archive/refs/tags/0.7.37.tar.gz"
  sha256 "ad6a38624dde26fc59c41427608536c443b76f90dcb6bb96c2e70b8e3ee20419"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b65aca1a7f1876cde376dbb21c43deecbda2644934ead2a5b5e7d090997593bb"
    sha256 cellar: :any,                 arm64_sequoia: "975c816a8e47eb9f8a9ee8b244c7039094971d38411e7a6bf3039bc3624febd5"
    sha256 cellar: :any,                 arm64_sonoma:  "be33a46245533a8a0e7672dff3b1adebb7b23cde1fa5d07ade115d5f738ae7dd"
    sha256 cellar: :any,                 sonoma:        "4fac39badbbf4a2662e9aecd4170957cd8c901ce641aad5bbabb91e9302b8030"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13fb5494c75df1f113dbbc51e649f3006f4471da2ad297be6f213780e3c70a4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f43a05ae93e5e41be66adf05a44e9fa681b09a8708600c6943932b705967dfe9"
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
