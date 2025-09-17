class Libgit2AT17 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "de384e29d7efc9330c6cdb126ebf88342b5025d920dcb7c645defad85195ea7f"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "c9039f1555118fffc0821412d2477be9c70922ac442e0146c50fa3583a6802a2"
    sha256 cellar: :any,                 arm64_sequoia:  "4194c7a41da5f78c05b33988fa28d163c60dc7146fdc964d82ed9b132c90ed3d"
    sha256 cellar: :any,                 arm64_sonoma:   "0cad95e1f543ee0a6af1472c5a17e8f5bf09dafab3862ed08bd46e8f44cb0575"
    sha256 cellar: :any,                 arm64_ventura:  "32585dd96ae9391b947813734680adef748792d6ead5ecdf3fbb8b9e495a069b"
    sha256 cellar: :any,                 arm64_monterey: "444563550469e0d842b57e68bcd2d6344c914f065033736e0f96f6a61cd00156"
    sha256 cellar: :any,                 sonoma:         "11fb0939977b4af263902257d496fe143276a489e2887c6f3c0382525a3bf281"
    sha256 cellar: :any,                 ventura:        "00ce19e60bbe028b8771d15b9b29b1d8d249211fd2f5c6e053ad8af3b52842c4"
    sha256 cellar: :any,                 monterey:       "d7c8dea4ca2f97faf4e37e618f469181d0c128208518b33fee1af1c60a86a301"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3e616b5960880f0abdb72f77aa469955d2a946c7683cfc29dc414f5c0d05df94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8357f3e14b1bec47984f48b9f3e4d21a2386f1c98e42c163081e812f93706027"
  end

  keg_only :versioned_formula

  # https://github.com/libgit2/libgit2/?tab=security-ov-file
  deprecate! date: "2025-01-08", because: :unsupported

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libssh2"
  depends_on "openssl@3"

  def install
    args = %w[-DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF -DUSE_SSH=ON]

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
