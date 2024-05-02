class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "https://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.1.tar.gz"
  sha256 "c672a6379142ac2e872741e7662f17eccd8230bffc680564d2843d87480f1600"
  license "AGPL-3.0-only"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e471c2d79859e1f8d856013abc79686966d9e4e0c7ef6f6a7136466574078fed"
    sha256 cellar: :any,                 arm64_ventura:  "b9aa7ab26bf730c3df6eeae83bdc61beea1340b544f525ad3d2884c971d91efb"
    sha256 cellar: :any,                 arm64_monterey: "63617b4fa7d506c842a902e1fe320fa6f683b9b308755f557c96c9d4f53074af"
    sha256 cellar: :any,                 sonoma:         "8529fb52ff2c52de1c6f85530b404c5682cc89ac2d92b1556c7ab6ecdac185b6"
    sha256 cellar: :any,                 ventura:        "95b5feff0cc251a693c95eeb6a94c3fb589977a8c57ba7a3fe904edea3bf42ee"
    sha256 cellar: :any,                 monterey:       "3994465596aa9bb62307f9dca37bed9fafe67d9c1e379666ec3fda6c742038f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9d22cf033e91e1dbce5faa57e0d52b2297795f77aecb162805dd6ff42cef85f"
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
