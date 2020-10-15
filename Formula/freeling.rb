class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "http://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.tar.gz"
  sha256 "ef0eac3c82b1d1eb6b87094043c744f6517b3bd639415040eaa6e1e6b298d425"
  license "AGPL-3.0-only"

  bottle do
    rebuild 1
    sha256 "680ce0ad080cd5e9b0415650464c198b9206ed1833791895322e5f0df4b781d5" => :catalina
    sha256 "120ce824973a4dec44ca66988d80b067dd47bee0ec4ee8bd052d8a5ed45840aa" => :mojave
    sha256 "11db1280b733420f74d65c273bb06884f93da15f91b954c5bb38bcca2ac45869" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c"

  conflicts_with "dynet", because: "freeling ships its own copy of dynet"
  conflicts_with "eigen", because: "freeling ships its own copy of eigen"
  conflicts_with "foma", because: "freeling ships its own copy of foma"
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
