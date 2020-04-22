class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "http://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.1/FreeLing-4.1.tar.gz"
  sha256 "ccb3322db6851075c9419bb5e472aa6b2e32cc7e9fa01981cff49ea3b212247e"
  revision 5

  bottle do
    sha256 "7777a7ca0c3a4cb72e9125d6413ee53b09800ef8a93c8cdcf4f24648ef7e2496" => :catalina
    sha256 "6de02b3f2b1cf9cc28ec450cb10cba002d6e5075e066f877e3e9caac44058941" => :mojave
    sha256 "c14f035f0f7297091d06a7523cab35aba5d1203ae6dc70793ed5c94692ba42bb" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c"

  conflicts_with "hunspell", :because => "both install 'analyze' binary"

  # Fix linking with icu4c
  patch do
    url "https://github.com/TALP-UPC/FreeLing/commit/5e323a5f3c7d2858a6ebb45617291b8d4126cedb.patch?full_index=1"
    sha256 "0814211cd1fb9b075d370f10df71a4398bc93d64fd7f32ccba1e34fb4e6b7452"
  end

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
