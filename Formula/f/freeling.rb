class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "https://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.1.tar.gz"
  sha256 "c672a6379142ac2e872741e7662f17eccd8230bffc680564d2843d87480f1600"
  license "AGPL-3.0-only"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c436822f827ecdb05423370a54d54bb07f45f84283bb3efba4908cd81bfc4f0f"
    sha256 cellar: :any,                 arm64_ventura:  "cb0d50895b60adfda24f6d8a12dc85c22656b06a33bc2a20c76f8726a131599f"
    sha256 cellar: :any,                 arm64_monterey: "280c67fe4d900d73e53e5a7e4b3c5a7101ac22c34f73dd6451f8e4fa4d45477e"
    sha256 cellar: :any,                 sonoma:         "2b45e79ad7eda63b866b481aa3465441423b07adca55525776b9c870c14e2dcb"
    sha256 cellar: :any,                 ventura:        "659234744bf618ccbbba0b5eda25455e1c8e774d7755e8bcd38e3ae7b14c124c"
    sha256 cellar: :any,                 monterey:       "22ea2fb09bf2226529ae1998757ccd2ee7a871adfb67452536f35698f20a246e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a6d604649fce1d2dfa81fc4056617cb5aab7d2bcb4bc44277709cbc8f67b38f"
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
