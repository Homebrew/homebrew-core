class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "http://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.1/FreeLing-4.1.tar.gz"
  sha256 "ccb3322db6851075c9419bb5e472aa6b2e32cc7e9fa01981cff49ea3b212247e"
  revision 4

  bottle do
    sha256 "ef41339b443cbacf31b4e67cfeb8574afcb6d1b180fba12635c351752b4994f8" => :catalina
    sha256 "3faed316cb8f13fafe70e3d6e838dd9f8ce11b8606a16b9368b348e56a701aac" => :mojave
    sha256 "8fd91b77f8dfc1aeb5bee785ccf8efa943aa534f993d32d64f800a1e64878c02" => :high_sierra
    sha256 "a3ec3ea6662f4c7ee75aa77c6fb76d63fcdda6c92d56afbd228807a4bb02f2c4" => :sierra
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
