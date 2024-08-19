class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "https://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.1.tar.gz"
  sha256 "c672a6379142ac2e872741e7662f17eccd8230bffc680564d2843d87480f1600"
  license "AGPL-3.0-only"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ecfc8921a5a1ce53c49dc24850bca48bb1c8877cf1784e03b5cff1e3bf2de19c"
    sha256 cellar: :any,                 arm64_ventura:  "801f54dc1051a01623a9503d4785d163125c46dfa1922fc08223d1aeeda4b4e7"
    sha256 cellar: :any,                 arm64_monterey: "75f5cd437c1988cec1a7c596b372929cdefe083cfd30bfaa9a27afa8c0cd943c"
    sha256 cellar: :any,                 sonoma:         "bc98a94ec428215d2a86dc80f8be616f6982293fab0ef530253607bbf32945fb"
    sha256 cellar: :any,                 ventura:        "7bbf13e7ba9759332834e77f7f993788becb51b2a770969c444d6b76d235f41d"
    sha256 cellar: :any,                 monterey:       "03fdbde545042f81bf8c7a4f18bd7d49bdf405e3625fa2a2c9598e6c72d12812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7d86da0c4348eaa3a2bd082920138234bbe0ef76fc238384a96144c67f3ef2d"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c"

  conflicts_with "dynet", because: "freeling ships its own copy of dynet"
  conflicts_with "eigen", because: "freeling ships its own copy of eigen"
  conflicts_with "foma", because: "freeling ships its own copy of foma"
  conflicts_with "hunspell", because: "both install 'analyze' binary"

  conflicts_with "crfsuite", because: "both install `crfsuite` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.install "#{bin}/fl_initialize"
    inreplace "#{bin}/analyze",
      ". $(cd $(dirname $0) && echo $PWD)/fl_initialize",
      ". #{libexec}/fl_initialize"
  end

  test do
    expected = <<~EOS
      Hello hello NN 1
      world world NN 1
    EOS
    assert_equal expected, pipe_output("#{bin}/analyze -f #{pkgshare}/config/en.cfg", "Hello world").chomp
  end
end
