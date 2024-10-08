class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "https://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.1.tar.gz"
  sha256 "c672a6379142ac2e872741e7662f17eccd8230bffc680564d2843d87480f1600"
  license "AGPL-3.0-only"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f0f0e3c141692fe62d6d1b4392ed2455083426962709498d85676ca1ecfef542"
    sha256 cellar: :any,                 arm64_sonoma:  "b80d16a431b0d304eccbce5229b4cba351b240598218ac966e506071953235c3"
    sha256 cellar: :any,                 arm64_ventura: "62077347e29ff817974bf37bfd12ff801c826963597776ee276db726fdb5497b"
    sha256 cellar: :any,                 sonoma:        "38ed7b6262161ba1b7974dbe1ee3c839bc66de5cf3a710e208bc4b8ebb44801f"
    sha256 cellar: :any,                 ventura:       "0501691716a64df0b3ed7dfaf77c5de04d6b6e1ddb6a5a16ab3ddb13d6c224cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2965621d075c50b1dfd196ca2dff63add2d3b6c2c9bd8521674fb2241e27178"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c@75"

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
