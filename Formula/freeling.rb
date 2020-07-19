class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "http://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/archive/4.1.1.tar.gz"
  sha256 "c58822f262e6a9c550ce7dd080025aa322a0801b61aff10d5d085f8c168bee60"
  license "AGPL-3.0"

  bottle do
    sha256 "5dd469d40bae3f742009896fa79d140730ebabcb2a3be596ac7f43eb223586c0" => :catalina
    sha256 "440b48a5861925c697ea0612ebbb5c62e6b7ac4ce86dc9e0c4beac2849e72a76" => :mojave
    sha256 "70f42b87f7684ca80c8c10d357225d2ae079c169255b79eec78c5757c2935475" => :high_sierra
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
