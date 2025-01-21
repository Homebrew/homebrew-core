class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "https://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.1.tar.gz"
  sha256 "c672a6379142ac2e872741e7662f17eccd8230bffc680564d2843d87480f1600"
  license "AGPL-3.0-only"
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d6acdd643de5c309907ceb793cd046cd8dd8ad28699322502b5dfb66a2242a2f"
    sha256 cellar: :any,                 arm64_sonoma:  "322a9d592bc73e998a38644941240636caa518d30116c1fa70f8d9239b000d30"
    sha256 cellar: :any,                 arm64_ventura: "fd3f956da818dd715eedc7b82f8bf0f5045a38021ccf1b000691811edf2f35a3"
    sha256 cellar: :any,                 sonoma:        "780a8288885a7e4577fd407cedd81431f52b7158ac46950623893e5cb2e17905"
    sha256 cellar: :any,                 ventura:       "506d8768088d58c6bb31306c78f1bd0470d3f1f06b0aab7a97897cf99056c4d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59dff48c765a92393305e2ed97eb4764fdfd458ff3d1e18dce973179dd3b3a3e"
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
