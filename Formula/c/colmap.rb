class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/3.8.tar.gz"
  sha256 "02288f8f61692fe38049d65608ed832b31246e7792692376afb712fa4cef8775"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3a0d7e341c1a9600b8caba970bee951d8b6d671fe9a263865eb589cb7d186aff"
    sha256 cellar: :any,                 arm64_ventura:  "68ef3a962421476e89e4e5c3a875b3701e5b88794222ba3e007334c3ccdfaf0b"
    sha256 cellar: :any,                 arm64_monterey: "7b53abdfe0eb5d6aa838fccf06ebe1df3879bec37bd9447675bc2ccde80dfdfc"
    sha256 cellar: :any,                 arm64_big_sur:  "50943e75c8594f7a28e39f5cc849e38a8a88df0fa214198a30f59a1ca9cd8c14"
    sha256 cellar: :any,                 sonoma:         "cf61dbc802d106d7f035eb6c5234940c7d28d3325615d0714583cf678c5546ae"
    sha256 cellar: :any,                 ventura:        "ab90a4cdc6c2de4bb1f90d962cd1a6740179bd0ee1d6d8df7d8afd53aa5b22ee"
    sha256 cellar: :any,                 monterey:       "799c8ca6554197413d7c16ce3d459017f6488ff33240e6f08c2a5fb178d804ec"
    sha256 cellar: :any,                 big_sur:        "1c168baf35d8e55e8b77d2230ebf220dfc4222a649e3ba023adfb44db172cfbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7199d1b452d304463ae3b3ceb28fc8936f6f191402e5e21f4dd2ecf8b115eb5b"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "ceres-solver"
  depends_on "cgal"
  depends_on "eigen"
  depends_on "flann"
  depends_on "freeimage"
  depends_on "gflags"
  depends_on "glew"
  depends_on "glog"
  depends_on "lz4"
  depends_on "metis"
  depends_on "qt@5"
  depends_on "suite-sparse"

  uses_from_macos "sqlite"

  def install
    ENV.append_path "CMAKE_PREFIX_PATH", Formula["qt@5"].prefix

    system "cmake", "-S", ".", "-B", "build", "-DCUDA_ENABLED=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/colmap", "database_creator", "--database_path", (testpath / "db")
    assert_path_exists (testpath / "db")
  end
end
