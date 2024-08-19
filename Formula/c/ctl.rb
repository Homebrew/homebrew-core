class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  url "https://github.com/ampas/CTL/archive/refs/tags/ctl-1.5.3.tar.gz"
  sha256 "0a9f5f3de8964ac5cca31597aca74bf915a3d8214e3276fdcb52c80ad25b0096"
  license "AMPAS"
  head "https://github.com/ampas/CTL.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "09e00ca81ea0579317522d47dc94b7569c0ec006779af1688e321db694be4039"
    sha256 cellar: :any,                 arm64_ventura:  "7a3fd5eca1686d5396816bc4f7110e49fa03d0c4e1d5a31e4e7a1797661e9379"
    sha256 cellar: :any,                 arm64_monterey: "18d01a3812983c2dda174e54a1ba361545be2e26977520d30209a232e67bd34b"
    sha256 cellar: :any,                 sonoma:         "87183233f8b431d80d3e3e0cc48a63640ab648cf8f8ee9e28ef28388a5f00ebe"
    sha256 cellar: :any,                 ventura:        "99dad1064acd32072818f9461897f7e135b3e83e74327470dee8fa471dbb67a6"
    sha256 cellar: :any,                 monterey:       "4654b4b1cd581df25409b0953009b57b7e8e58c15e55a459e068cee4b1c18661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41978658fbcaa4a098be2a6cb93fc4ee0240b3bc3fc7663a84f54a04e58d3fcf"
  end

  depends_on "cmake" => :build
  depends_on "aces_container"
  depends_on "imath"
  depends_on "libtiff"
  depends_on "openexr"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCTL_BUILD_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "transforms an image", shell_output("#{bin}/ctlrender -help", 1)
  end
end
