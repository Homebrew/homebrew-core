class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "https://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.1.tar.gz"
  sha256 "c672a6379142ac2e872741e7662f17eccd8230bffc680564d2843d87480f1600"
  license "AGPL-3.0-only"
  revision 9

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "7818f5931f6a47b3b1347f40740e9ed5d69497b35273d05751f50b3b7aae780c"
    sha256 cellar: :any,                 arm64_sonoma:  "830fc63ec3e39530597595fb83f2545f4011aa2bd3db2b8348c3b914aec34a7f"
    sha256 cellar: :any,                 arm64_ventura: "3688000fe9494bf4481c2ecaff45fbbb90de39f450fdbd35c95d9200f896c8c6"
    sha256 cellar: :any,                 sonoma:        "02928e1c1d2de345657a5296ec2aba68903ed41b759a533c05c0f73404153a9a"
    sha256 cellar: :any,                 ventura:       "ddca7f21d90216b356ea852e14d23e5299d0032b7109a5e19a7666b252db3143"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb210c6225a736bfa6da23f2cfdd51496781bf7b2ec93c761aee1ad12040465c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df83bdff0215c970ec2cbddda96458f831f527cfcbe8f165994e69d66fbaef3d"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "dynet"
  depends_on "icu4c@77"

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
