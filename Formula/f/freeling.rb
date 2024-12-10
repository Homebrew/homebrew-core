class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "https://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.1.tar.gz"
  sha256 "c672a6379142ac2e872741e7662f17eccd8230bffc680564d2843d87480f1600"
  license "AGPL-3.0-only"
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bb16cae69ece5d45a27ec4e4a7c19f767bae6e86adde1b7c6cc62eebf5f0f332"
    sha256 cellar: :any,                 arm64_sonoma:  "32f84651b83687a37d38186b3ca30ed6d1a756de7b8079350a58e29779a8a916"
    sha256 cellar: :any,                 arm64_ventura: "6049a2e53d726ad543ba69b973fc23d7296146d74e2620ae5aebb6ddcacfa684"
    sha256 cellar: :any,                 sonoma:        "d55210dda67692917cf299ae755baf1ab8cc97903c8b7258f2f5169f403b3727"
    sha256 cellar: :any,                 ventura:       "2d54a7d0dba20a3e9674bff837ad222745650f66598d8a24d50f40d3d1bc92eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c64d78b21c012aed472e1345e742211129771abe3c3c3250bc965283f6141fc"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c@76"

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
