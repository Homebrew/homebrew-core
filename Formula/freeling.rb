class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "http://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.tar.gz"
  sha256 "ef0eac3c82b1d1eb6b87094043c744f6517b3bd639415040eaa6e1e6b298d425"
  license "AGPL-3.0"

  bottle do
    sha256 "3e5cbfb547396e03170a5c393b5fa5597fbbfef82d386b3cdaa808a8ab024737" => :catalina
    sha256 "da007f9042a7d187f257c27045071ee615c9f17fab1975d05dfdc5b23a526000" => :mojave
    sha256 "083f4a759fdd2f8a482d4e1ee0f804eafd1562434cc95136e082befbd4ca5544" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c"

  conflicts_with "hunspell", because: "both install 'analyze' binary"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end

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
