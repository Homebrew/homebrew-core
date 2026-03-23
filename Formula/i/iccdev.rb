class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.5.tar.gz"
  sha256 "b475e0f42b41a53689d0e67d86eddb902156183fd4de3742c6a5c18f5b065048"
  license "BSD-3-Clause"

  # Skip `wasm-` tags
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bd74477116a0e2c2e0e842c6650f9d27fedf3a3ac3dc1ceb8d62063031f7d34c"
    sha256 cellar: :any,                 arm64_sequoia: "93ae485471749e3bd7bda7973b103e2b24737d9265d0b715e6d8373bb040f1ed"
    sha256 cellar: :any,                 arm64_sonoma:  "337d4907871bea4d95bd52e0f65c9ac8da54339bcec876930562eba762e26e77"
    sha256 cellar: :any,                 sonoma:        "f597aa258193d6774f669818a4503fe0c857e462e679b8b8a8d9943109a961e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38021eddee86c800e712d71279d507941a40bc6df4d4f9541f174024782c78a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e54aa6f7fae5b7bc4b14c07ceca75f81ba83aecf957641ede12552a02ca53cf8"
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
