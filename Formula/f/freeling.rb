class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "https://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.1.tar.gz"
  sha256 "c672a6379142ac2e872741e7662f17eccd8230bffc680564d2843d87480f1600"
  license "AGPL-3.0-only"
  revision 12

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f52d5f615f623c4b8370bd5f03ea156da7a4a5f5e1eaf6d63fa6073a9b741f82"
    sha256 cellar: :any,                 arm64_sequoia: "f6851b8266fbb47b155f46e8ef1bb86d4be27c31795314b30922bbd554eb223a"
    sha256 cellar: :any,                 arm64_sonoma:  "21b03d396a4e4d55031d4e5f0ff72ed7162af9ea1f88ccb73931465664ed9ccd"
    sha256 cellar: :any,                 sonoma:        "c82c10eb1d8d237f771cb39f7cbbabe930e04c128f7433100cb1b2e77313c56b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cef326658f4d61c5a757a4571d62a02cc78cdf4049463594321e83b70d2c51e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8901505faeac339eb4a73a7bdb9c71329423e73afb5523473cfdef72e93ddb94"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "dynet"
  depends_on "icu4c@78"

  uses_from_macos "zlib"

  conflicts_with "foma", because: "freeling ships its own copy of foma"
  conflicts_with "hunspell", because: "both install 'analyze' binary"
  conflicts_with "crfsuite", because: "both install `crfsuite` binaries"

  def install
    # Unbundle `dynet` and its dependency `eigen`
    rm_r(["src/eigen3", "src/libdynet"])
    (buildpath/"src/eigen3").mkpath
    (buildpath/"src/libdynet/CMakeLists.txt").write ""

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
