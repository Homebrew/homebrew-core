class Clip < Formula
  desc "Create high-quality charts from the command-line"
  homepage "https://github.com/asmuth/clip"
  url "https://github.com/asmuth/clip/archive/v0.7.tar.gz"
  sha256 "f38f455cf3e9201614ac71d8a871e4ff94a6e4cf461fd5bf81bdf457ba2e6b3e"
  license "Apache-2.0"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "8676450d6feb3f337e4b6ad2ec8f6d278423df6d7dcccaece3c6254a23257493"
    sha256 cellar: :any,                 arm64_monterey: "8219feaf67b50d5c9645289e981834e0202e2de96fa0af9f087a85d5a68b0a08"
    sha256 cellar: :any,                 arm64_big_sur:  "40bf4ac77feee0c17ffbd6752aadcbe176de0bd4ceb9705089e666f1015d2c59"
    sha256 cellar: :any,                 ventura:        "080520de23838289c0c36e803b8cc634a557f1590fb38101ed5e34016593109c"
    sha256 cellar: :any,                 monterey:       "e7942d86f1258ab17333143d5f91c652208e50a14d7a6d9d01b6cfe4125210e8"
    sha256 cellar: :any,                 big_sur:        "ca8590a1b7257c1446fa8584840c6464b3d96249b1a3f4a88088c4b33e056ea8"
    sha256 cellar: :any,                 catalina:       "25a71994c609b8f6dc7ba6bfd8419dff71ce3263b59c6f75f394dd782ac26208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8860d063c5bd9d99437ce78fdab31324061ede3b54a2ba41b509a944c1f82b96"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fmt"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"

  fails_with gcc: "5" # for C++17

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test", testpath
    system "#{bin}/clip", "--export", "chart.svg",
           "test/examples/charts_basic_areachart.clp"
    assert_predicate testpath/"chart.svg", :exist?
  end
end
