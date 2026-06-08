class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.2.1.tar.gz"
  sha256 "9e990e38881d34d0c31aa7f0035d62376c3f58a6d0d891723663b35776090da9"
  license "BSD-3-Clause"

  # Skip `wasm-` tags
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5efb651a86be2784cb8e74b446b38f50c814d9ef652690a09646db241836d0b0"
    sha256 cellar: :any, arm64_sequoia: "b7c05ab1ab2bf1d9646c055c16da5a705f28e7a5228aa396f569556ec4e8079e"
    sha256 cellar: :any, arm64_sonoma:  "21daf21c5f139592dc699941ae43e713f5fa96a1c3c94a8c2d62db67b2d258a0"
    sha256 cellar: :any, sonoma:        "ed14b2c1860aecc557369e53bafa8afa5c68ec952a3bb129321f08b81fd4a1d3"
    sha256 cellar: :any, arm64_linux:   "f4e3b59077814b855ee8a8b01522e654c8843627b926d2ca03e8d6b04912518c"
    sha256 cellar: :any, x86_64_linux:  "767066b063a6e7655a1c7bda3646e6e85b14fbce807d898ce52380f3a75e8c11"
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
