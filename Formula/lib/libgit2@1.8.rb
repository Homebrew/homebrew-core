class Libgit2AT18 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.org/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "ec70049b8af823b21032447f91a2274fd8d91c435ef326a533dff3824e21b27f"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }

  livecheck do
    url :stable
    regex(/^v?(1\.8(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "906d5ccc5117c9e2c7273223571961fbc1942a61c652ed31f494f85423069af2"
    sha256 cellar: :any,                 arm64_sequoia: "9a7f4f48320b87e7067589fb218d6edf9513f7ca9d522cbc2e119b002409ce8e"
    sha256 cellar: :any,                 arm64_sonoma:  "b062e85c407f021ec8541b55c9f08787d665e61762f0834c29fee0fce2f2558d"
    sha256 cellar: :any,                 tahoe:         "f13c93f8f111aa5b58366fae780223237438c3486be7481b4263bbad0a23dcee"
    sha256 cellar: :any,                 sequoia:       "7e5064dbf31f18bf27010982d08f752bd478ebedd1377ed55fb262503f16a305"
    sha256 cellar: :any,                 sonoma:        "b1175c63eaade8f8df89fbbe12a77f45d902c72566b3e6a14b977363b19a7b7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1feecd76d9334b09f4a24b69eb19af77910d1e1d5b83508ea115e3c63bb50d98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a03d39fce85a0f92345248fcdfff263023ee9eaf6a1b0103191d4302f5bddde"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libssh2"

  on_linux do
    depends_on "openssl@3" # Uses SecureTransport on macOS.
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[-DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF -DUSE_SSH=ON -DUSE_BUNDLED_ZLIB=OFF]

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-static/libgit2.a"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <git2.h>
      #include <assert.h>

      int main(int argc, char *argv[]) {
        int options = git_libgit2_features();
        assert(options & GIT_FEATURE_SSH);
        return 0;
      }
    C
    libssh2 = Formula["libssh2"]
    flags = %W[
      -I#{include}
      -I#{libssh2.opt_include}
      -L#{lib}
      -lgit2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
