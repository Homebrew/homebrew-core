class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.7.tar.gz"
  sha256 "56bda64c8a88967087d5a11ab6a86c23dc27f32c9c084df0f623d7a7f06fe84f"
  license "BSD-3-Clause"

  # Skip `wasm-` tags
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "608cd6ba68569458838f907e3e0e05905f07614f9b7e310d7ef7ea8a1e9e2796"
    sha256 cellar: :any,                 arm64_sequoia: "5127db1a30cfdcaff7f28d9ab2f2e173bcb1eebbcd222c141923d9b09814f46a"
    sha256 cellar: :any,                 arm64_sonoma:  "5035a6805d4fcfdf4ec851710b1960110d12c564c974eb8cab4ddee0207f76f4"
    sha256 cellar: :any,                 sonoma:        "78fb28f6cc085ef82f9737a0bba580870226cb247b551ecf7a075cecb69d09c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1c85d71ea4d3d4261bb01d4dd3bd6bce90f0751f0aa8916d375db2c8023e21a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fa9d1c811c0e54d3af2208031048de9c4a6f5026164050dfed5d073a7104d8a"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "wxwidgets"

  uses_from_macos "libxml2"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", "Build/Cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "Testing/Calc/CameraModel.xml"
  end

  test do
    system bin/"iccFromXml", pkgshare/"CameraModel.xml", "output.icc"
    assert_path_exists testpath/"output.icc"

    system bin/"iccToXml", "output.icc", "output.xml"
    assert_path_exists testpath/"output.xml"
  end
end
