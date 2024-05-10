class Editorconfig < Formula
  desc "Maintain consistent coding style between multiple editors"
  homepage "https://editorconfig.org/"
  url "https://github.com/editorconfig/editorconfig-core-c/archive/refs/tags/v0.12.7.tar.gz"
  sha256 "f89d2e144fd67bdf0d7acfb2ac7618c6f087e1b3f2c3a707656b4180df422195"
  license "BSD-2-Clause"
  head "https://github.com/editorconfig/editorconfig-core-c.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "87e98021bc4ca6716bca5b718aec48e06b9d8f368750e4c405cc93b7c7ac867a"
    sha256 cellar: :any,                 arm64_ventura:  "8b9bda4f3cbee981a74cbca64331ec8f890a0eb543175e80793e7e576602833f"
    sha256 cellar: :any,                 arm64_monterey: "bbd3db4eed09b17e854f6f5084be4863333a90b992506876f91cdf10859558ae"
    sha256 cellar: :any,                 sonoma:         "8d055717b9ae6a5670a09bbab889f72527146186bcb94b2c602d494e6e57e022"
    sha256 cellar: :any,                 ventura:        "a0115a90471b78d8e388be35c7c31afea16b95aaf829bd1e603923eefbaf1e66"
    sha256 cellar: :any,                 monterey:       "a853135c8a181016179ae4b456701c335847e922e83eb762f09946b502f7bc03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ac77d6f5822633b872ea55d26d4376f807e3469a6471e0c32ba4f4037b8fa5a"
  end

  depends_on "cmake" => :build
  depends_on "pcre2"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/editorconfig", "--version"
  end
end
