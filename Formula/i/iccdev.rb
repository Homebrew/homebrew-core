class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.2.0.tar.gz"
  sha256 "29a894a18d4535c6ba324fcbe1e43b4bfc3408781cc940e5d8144f4b3bd7f0cf"
  license "BSD-3-Clause"

  # Skip `wasm-` tags
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "430275addcb0fb49c7fef903c3d03667ed7cb19caafd9560a64133b21170e30c"
    sha256 cellar: :any,                 arm64_sequoia: "3b7546ec520d0467e490acc641b4e91399879a4400036b21e3180e3ce14d8d43"
    sha256 cellar: :any,                 arm64_sonoma:  "fd3e447e76b72b39f4963df26f0f46dadc480ea3f104a6acbdcc8ba5ef7d8134"
    sha256 cellar: :any,                 sonoma:        "48e3228f424fc5f77e65b3a706d2cbb3133de6a1fc7948233f3fed1b1cb94561"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa161a2e4e04f279d828abbf411be3deaec927baf2c12d3e3342c94448b9096f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7611d52b7ea1e076e52abf4f0c12a5d5105562b57184f999e78d194c30c17b7d"
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
