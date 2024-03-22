class Mapcrafter < Formula
  desc "Minecraft map renderer"
  homepage "https://mapcrafter.org"
  url "https://github.com/mapcrafter/mapcrafter/archive/refs/tags/v.2.4.tar.gz"
  sha256 "f3b698d34c02c2da0c4d2b7f4e251bcba058d0d1e4479c0418eeba264d1c8dae"
  license "GPL-3.0"
  revision 10

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e2f94fcaa7b91042cb6ab1252f58bcd9edc1e46e07ffc08c792a35af72c15acb"
    sha256 cellar: :any,                 arm64_ventura:  "9d707ef1c4a74e52d82215e9efeb1f1a09c1965957c757b8e8b82052eed9c9e8"
    sha256 cellar: :any,                 arm64_monterey: "fe6d50dbd9cc83ba9cfb13c096f9b41caf17c9f2be8782ae594ce5121413d649"
    sha256 cellar: :any,                 sonoma:         "e5bd9ce74f32e318e75081ff765886535989734d35fa8b955a54a06f4aea55cf"
    sha256 cellar: :any,                 ventura:        "19c03724a9d64a9447cef9117145e8790975cb7889873146c1e1d8efc8c19ffb"
    sha256 cellar: :any,                 monterey:       "2b27c6005892c49ae36bf09470787a96203e193be537be62e7e52f69d20afe4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56521c291750a553f8cfe637ad8399d598443de08a0ac98081ad798dd127eb12"
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
