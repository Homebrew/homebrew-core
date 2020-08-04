class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "http://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.tar.gz"
  sha256 "ef0eac3c82b1d1eb6b87094043c744f6517b3bd639415040eaa6e1e6b298d425"
  license "AGPL-3.0"

  bottle do
    sha256 "22ee0da143b9d7f402e36992a215891898c9cd9dc0caef7671126b841eca0402" => :catalina
    sha256 "fdbea1f56535241d510d41c2e388045b402c8385528910a4f1b5f60aa12d364f" => :mojave
    sha256 "e8bc020fb721b127999afa30985aa80de79baf62d70a838217730f6c89ddaed3" => :high_sierra
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
