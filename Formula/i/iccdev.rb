class Iccdev < Formula
  desc "Demonstration Implementation for iccMAX color profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.2.50.tar.gz"
  sha256 "3ef14e8d143705eced1b3120dcc16d6b8730dac7754fae7fef6861eb53836b56"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a24e4a3fbc61f165a94024e28565824080c26f24a5a3a69de8a50a65fb22ad63"
    sha256 cellar: :any,                 arm64_sequoia: "175c33091f3aeed27ae062dc2aa90c292eb34ef9e0d28aee21150d298fc7cabf"
    sha256 cellar: :any,                 arm64_sonoma:  "5112b2beaf6414f3d5d7de5d2d62d9c71898c6ec7a0aecb88bb85fe00b0d4972"
    sha256 cellar: :any,                 sonoma:        "98df46395d9a21e05a228a3adb86fddf1833b5bb05336500bbb5309c5e57b9c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d8895eeb009d41b403cd567cd5f1b3a8779e38d54dd365b28ffc2712b667f30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fd54467f13174a21b8cb3b7cf2850a8c8bebc8339c5949a818abfa21951afd2"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "wxwidgets"

  uses_from_macos "libxml2"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DENABLE_TOOLS=ON
      -DENABLE_SHARED_LIBS=ON
      -DENABLE_INSTALL_RIM=ON
      -DENABLE_ICCXML=ON
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
