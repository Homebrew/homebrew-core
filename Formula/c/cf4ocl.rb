class Cf4ocl < Formula
  desc "C Framework for OpenCL"
  homepage "https://nunofachada.github.io/cf4ocl/"
  url "https://github.com/nunofachada/cf4ocl/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "662c2cc4e035da3e0663be54efaab1c7fedc637955a563a85c332ac195d72cfa"
  license "LGPL-3.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "918ad2b60fb6b57e75f4ed4c5d39e00be444540b6d6acf2ebd4a3aca65b2f379"
    sha256 cellar: :any,                 arm64_big_sur:  "1dd45839fde1e811c48f46dbb2341aa58523b7b383fe63dd9455bac0b6341c44"
    sha256 cellar: :any,                 sonoma:         "41920b649b63c17803f38f53137f5e139cd879a836bdc6b9367657478c5f1f63"
    sha256 cellar: :any,                 ventura:        "fef74ca6cee236243b8f1a17567b92dab6a7c8d8409bfe70cc25af3c62046c11"
    sha256 cellar: :any,                 monterey:       "0fbae4ce46da802207e1ec4bc0c950505e19fa8c26e1d6cd214a02bbaaa7b3b4"
    sha256 cellar: :any,                 big_sur:        "cc8b6ca2880efe29c48df37e31c72dc16e3826444ab73491e15ce4e17de0b7c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24717beaa49876d58f32115ed8ce7d6d9e25b298dcf96ce4170b58dd13f062b3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_TESTS=OFF",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # OpenCL does not work on ephemeral ARM CI.
    if Hardware::CPU.virtualized? && Hardware::CPU.arm? && OS.mac?
      assert_match "OpenCL error -30: Invalid value", shell_output(bin/"ccl_devinfo 2>&1", 1)
    else
      assert_match(/TYPE\s+\|\s+[CG]PU/, shell_output(bin/"ccl_devinfo 2>&1"))
    end
  end
end
