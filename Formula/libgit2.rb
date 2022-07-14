class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v1.5.0.tar.gz"
  sha256 "8de872a0f201b33d9522b817c92e14edb4efad18dae95cf156cf240b2efff93e"
  license "GPL-2.0-only"
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "332c012c8f5218acc8e02d076d6f588a7a894544d53fc8b38d11bf3eb6c9cc3d"
    sha256 cellar: :any,                 arm64_big_sur:  "ce3c004de97ade23b818f3e039fb1b512d9d6a0e1b10e199ca497bd7ed202bb7"
    sha256 cellar: :any,                 monterey:       "fc0f26f5383d478d225ee126ed802656b0490817a69f5b066f7902c168ec2576"
    sha256 cellar: :any,                 big_sur:        "79f8276aa1edb0286d573ae91e06f009e951ed0fbe5dedb5dead84d1106a5de0"
    sha256 cellar: :any,                 catalina:       "49b7ca1f4c469f91b91a1232f6fad32f507bcf5a57c45ee4c362b012d4ce7350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5e2330130e07eefae1c03d7e563335d197cd055ce6b2fa4ebe630f4b0c9c089"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libssh2"

  def install
    args = std_cmake_args
    args << "-DBUILD_EXAMPLES=YES"
    args << "-DBUILD_TESTS=OFF" # Don't build tests.
    args << "-DUSE_SSH=YES"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      cd "examples" do
        (pkgshare/"examples").install "lg2"
      end
      system "make", "clean"
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *args
      system "make"
      lib.install "libgit2.a"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <git2.h>
      #include <assert.h>

      int main(int argc, char *argv[]) {
        int options = git_libgit2_features();
        assert(options & GIT_FEATURE_SSH);
        return 0;
      }
    EOS
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
