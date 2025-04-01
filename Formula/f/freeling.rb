class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "https://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.1.tar.gz"
  sha256 "c672a6379142ac2e872741e7662f17eccd8230bffc680564d2843d87480f1600"
  license "AGPL-3.0-only"
  revision 10

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a39522d63dba5e77890732894b0ebce8c76a507746857c5a500612804ee54c75"
    sha256 cellar: :any,                 arm64_sonoma:  "c0b8134c5f6b1db66767f4aa45c1c0390c653c545c63f520630efdb9e22a0d5c"
    sha256 cellar: :any,                 arm64_ventura: "004a2603e297798074b1e4660c16ac8e52a62b45149de4260e77099665616c19"
    sha256 cellar: :any,                 sonoma:        "cab5afd3f15d172c250d5053bb84c8feb53532d97116d8e03e573b37bd391914"
    sha256 cellar: :any,                 ventura:       "0e8c0d5db45751070ef1c9d0c97f01b58be075a4258724face8d8a91ae08af7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "954cf8858d578a5265c48c21cd105aa911fad1fae1c2b1d6b5a0d0d7342ccbb4"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c@77"

  uses_from_macos "zlib"

  conflicts_with "dynet", because: "freeling ships its own copy of dynet"
  conflicts_with "eigen", because: "freeling ships its own copy of eigen"
  conflicts_with "foma", because: "freeling ships its own copy of foma"
  conflicts_with "hunspell", because: "both install 'analyze' binary"
  conflicts_with "crfsuite", because: "both install `crfsuite` binaries"

  def install
    # icu4c 75+ needs C++17
    inreplace "CMakeLists.txt", "set(CMAKE_CXX_STANDARD 11)", "set(CMAKE_CXX_STANDARD 17)"

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
