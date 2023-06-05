class Colmap < Formula
  desc "General-purpose Structure-from-Motion (SfM) and Multi-View Stereo (MVS) pipeline"
  homepage "https://colmap.github.io"
  url "https://github.com/colmap/colmap/archive/refs/tags/3.8.tar.gz"
  sha256 "02288f8f61692fe38049d65608ed832b31246e7792692376afb712fa4cef8775"
  license "BSD-3-Clause"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
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
  uses_from_macos "sqlite"

  def install
    system "cmake", "-B", "build", ".", "-GNinja", *std_cmake_args
    cd "build" do
      system "ninja", "install"
    end
  end

  test do
    system "#{bin}/colmap", "database_creator", "--database_path", (testpath / "db")
    assert_path_exists (testpath / "db")
  end
end
