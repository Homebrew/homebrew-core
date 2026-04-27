class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.8.tar.gz"
  sha256 "da54ce760c4eb18d743279f001b17b1a28b23b35896e4bf7fbd9bf979e23b1c6"
  license "BSD-3-Clause"

  # Skip `wasm-` tags
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7f98ce4d01086f9e94ca92820d7f63d488c85569fff05847aa096de009d4c821"
    sha256 cellar: :any,                 arm64_sequoia: "48e1f344a9344a552a3542f0343d23b4c4bc4f7fb9e21df451a8fd220cb44990"
    sha256 cellar: :any,                 arm64_sonoma:  "12eae541a244e93532dc80e68390578b442a934df89f2a5ed5d6c1742140b21d"
    sha256 cellar: :any,                 sonoma:        "5f8624429e189a90f6659123874820e337cf384f6c6cb59b0d6af737a9150efb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46df5b83e288d9d2bb9806b0a11889bfb8405dbc37f3c9ca1d0074fc8c301699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "072a245a08abe5eaa581c09cefbf114b2d058b6bcf57b40f929a9e79876118a8"
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
