class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "https://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.1.tar.gz"
  sha256 "c672a6379142ac2e872741e7662f17eccd8230bffc680564d2843d87480f1600"
  license "AGPL-3.0-only"
  revision 13

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e156b45ac74b87aa415932e5577173796a7b77207708b9b599200b7438bc86ac"
    sha256 cellar: :any,                 arm64_sequoia: "7260ffdbaeef2635424243bef7a16d75f32361d81b4f1946691a6a8ad0f10662"
    sha256 cellar: :any,                 arm64_sonoma:  "b24bc3defe2c34f3b8eaaf8d68fedfc86a48a9b771db05a2270af3cdebc02a0d"
    sha256 cellar: :any,                 sonoma:        "05668767c7bb58eb8df2200c2da8da1c8f941a23e06eddbd1675e5d53aeeb309"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10357fffdd9dcc0bce6b4e234caae1d60e2c996a6260d97cdf3ba6380219e754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8314e02d61508254e04ef46a8a6a0bebc8817ef9ba265536da3065b92915b6cc"
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
