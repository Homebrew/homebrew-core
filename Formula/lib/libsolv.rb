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
    sha256 cellar: :any,                 arm64_tahoe:   "16b54630884fdaea477f8e8284f50ffd38f323bd213741b6fe369117a7447dc3"
    sha256 cellar: :any,                 arm64_sequoia: "9c7625f5743db89c31814320395d5f7f6b2e9edf75d62b22f78370f524024ddf"
    sha256 cellar: :any,                 arm64_sonoma:  "b67c4fe1fc284f1521babdaa64b30928ca2382d2f933e41cf20a284f20a4c8a3"
    sha256 cellar: :any,                 arm64_ventura: "65f85cff59024135a62a98eef81ae68b7bc2c4318d0540925b5704875e7e22ec"
    sha256 cellar: :any,                 sonoma:        "cae4d5f9a4d6dc8ba94b2b41869aa7a2b69d881252b8c0ea061d62050713c322"
    sha256 cellar: :any,                 ventura:       "79bd16f6009b2a41f9ba5dbe3e1c7bfd5968efdad36aa747b2999da360aa4b68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "600392ccca44e48deacb311dd4e9f3d40e140570fb3432f42bd4ef25c810f4af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "443ab1cdcf1ab640afeb091caca6bb24f3912aa7dc95f64c7d7c12dd09bbac1a"
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
