class Mapcrafter < Formula
  desc "Minecraft map renderer"
  homepage "https://mapcrafter.org"
  url "https://github.com/mapcrafter/mapcrafter/archive/v.2.4.tar.gz"
  sha256 "f3b698d34c02c2da0c4d2b7f4e251bcba058d0d1e4479c0418eeba264d1c8dae"
  license "GPL-3.0"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "09a0ca21ab205a905c30443647581723126b109a30f98d945006aab5d9bfe4e6"
    sha256 cellar: :any,                 arm64_monterey: "dd3b387299e1d45005f90a4455a8f3f4498554b1fc0b24523f83ee652f42934b"
    sha256 cellar: :any,                 arm64_big_sur:  "ffc7f348ec306fff455b9b64e160758f787795120efc863dc1e60744cd5ca444"
    sha256 cellar: :any,                 ventura:        "4e534e2b7cbe4565a37d45075b79f31f2505f88f00271d667d278dcfcb07c139"
    sha256 cellar: :any,                 monterey:       "2b099964a12b9d44b6ce7f6f09a227213f4308b4bf0751b1bd21e177f48fb190"
    sha256 cellar: :any,                 big_sur:        "12e1d407b240c0aac77be423235a6636ffc3ecc2b15d07f568286f0d534c7b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af8d1f5d66243ddbd1dd66fa3c2867ac516b387e8e7a931f4134d4fa01ee809f"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  def install
    ENV.cxx11

    args = std_cmake_args
    args << "-DJPEG_INCLUDE_DIR=#{Formula["jpeg-turbo"].opt_include}"
    args << "-DJPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_lib/shared_library("libjpeg")}"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    assert_match(/Mapcrafter/,
      shell_output("#{bin}/mapcrafter --version"))
  end
end
