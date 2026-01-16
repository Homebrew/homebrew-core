class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/3.13.0.tar.gz"
  sha256 "98a8f8cf6358774be223239a9b034cc9d55bf66c43f54fc6ddea9128a1ee197a"
  license "BSD-3-Clause"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "273fa82688837e3449adf2b091c78e8918b4bee3da0c2938e9384eb5a4281f08"
    sha256 cellar: :any,                 arm64_sequoia: "754630274595bb51fbeb7db1f20caefc5eb312374c19714513e15541fc012097"
    sha256 cellar: :any,                 arm64_sonoma:  "dde86a912dab2c0ca90bc1380e2ccaf938de190ac3e5cd6329e833e6b4b6f5eb"
    sha256 cellar: :any,                 sonoma:        "a2e612e8e03bf4f30c81bdbee45b939a4150672a16f9e44cae61ddb7123439a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6f2241b6a816fedfbd23291b6bbd453697d27f93658831cc6532f06ac37edb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85d8ebdf751827ca251fb71d5aaeb90282fa2de4968d9704557af20a099a3e9e"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "ceres-solver"
  depends_on "cgal"
  depends_on "eigen" => :no_linkage
  depends_on "faiss"
  depends_on "flann"
  depends_on "gflags"
  depends_on "glew"
  depends_on "glog"
  depends_on "gmp"
  depends_on "lz4"
  depends_on "metis"
  depends_on "openimageio"
  depends_on "openssl@3"
  depends_on "poselib"
  depends_on "qtbase"
  depends_on "suite-sparse"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  on_macos do
    depends_on "libomp"
    depends_on "mpfr"
    depends_on "sqlite"
  end

  on_linux do
    depends_on "mesa"
  end

  # Backport support for OpenimageIO
  patch :DATA # https://github.com/colmap/colmap/commit/c9e6ba0e63f1eaf9b4de985228da27ee6ec4c1f1
  patch do
    url "https://github.com/colmap/colmap/commit/083f4dee70b23f25729ed6d6c6fe9abc340b205e.patch?full_index=1"
    sha256 "226dfaaf179ad650ce535f6a3f6cbb9f93bfec2587bef5eb4d2d789a2c782e44"
  end
  patch do
    url "https://github.com/colmap/colmap/commit/8e014c5bc70c7e01506f1d5ef7daaf25dc3190ae.patch?full_index=1"
    sha256 "368e697f9cc863bdb706c99383aefa81d6be2ba373285a2a398fb69aa6bb7390"
  end
  patch do
    url "https://github.com/colmap/colmap/commit/74eeb69c62998c32dd8981b301956aaacec71596.patch?full_index=1"
    sha256 "e8a8ff862a38b80d2531f2300d1817fc7f132ee8c11b0f813b1d17f02309d25b"
  end
  patch do
    url "https://github.com/colmap/colmap/commit/70358de550ab47b0b83c3e5812d42ec8e2d41b22.patch?full_index=1"
    sha256 "ffc001e4d18dee24a47d262bc0e4e30906ee51ad5f8d38e81aed6284d75b9daf"
  end

  def install
    args = %w[
      -DCUDA_ENABLED=OFF
      -DFETCH_POSELIB=OFF
      -DFETCH_FAISS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"colmap", "database_creator", "--database_path", (testpath / "db")
    assert_path_exists (testpath / "db")
  end
end

__END__
diff --git a/.github/workflows/build-ubuntu.yml b/.github/workflows/build-ubuntu.yml
index f19bac5237..e793ea64f3 100644
--- a/.github/workflows/build-ubuntu.yml
+++ b/.github/workflows/build-ubuntu.yml
@@ -145,6 +145,7 @@ jobs:
             libboost-system-dev \
             libeigen3-dev \
             libceres-dev \
+            libsuitesparse-dev \
             libfreeimage-dev \
             libmetis-dev \
             libgoogle-glog-dev \
