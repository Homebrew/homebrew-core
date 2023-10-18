class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "https://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.1.tar.gz"
  sha256 "c672a6379142ac2e872741e7662f17eccd8230bffc680564d2843d87480f1600"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f6c73b22c6f39bf934cb3302d3e85c4199cb46aa99dcebcc605db14c745c09ca"
    sha256 cellar: :any,                 arm64_ventura:  "ac2822ac4f5c777cc7bef01ac5b57e1c77ba193817f8e1d1d57b19fbb25a77ce"
    sha256 cellar: :any,                 arm64_monterey: "c2788cb4af12d5fa65c214cb1d0af80b747fb83cc51cb5d788fb6f1462bfc80f"
    sha256 cellar: :any,                 arm64_big_sur:  "ca7bc8d5219f6bac9051a19e9404fd5452876260c9dd16b96e0f10c80f6b90a4"
    sha256 cellar: :any,                 sonoma:         "0480051aa02568d956e4583f16c5be11f3695ef7c81eff0609d4c6e45ed854b0"
    sha256 cellar: :any,                 ventura:        "321c4a350ec1b843723b2ff0cea9b4633a4c33b73f3aa7080b5831abecfc245a"
    sha256 cellar: :any,                 monterey:       "42ce7757ef606fae613b6db9a1c66af4e7270b23002785dac583abcccad87aa7"
    sha256 cellar: :any,                 big_sur:        "47ebbfe29be84a737912f9aba05df90520b2fa76730f90f295991603c20d79ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35f72701267b2a0fd8bbc46e6e24b79cebb2b9326da5280d4504cc15cf3c3e56"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c"

  conflicts_with "dynet", because: "freeling ships its own copy of dynet"
  conflicts_with "eigen", because: "freeling ships its own copy of eigen"
  conflicts_with "foma", because: "freeling ships its own copy of foma"
  conflicts_with "hunspell", because: "both install 'analyze' binary"

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
