class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.38.4.tar.xz"
  sha256 "a8ba1dc52ee82562abd57e9546c409f2f887f45187aae012fe43af0b730611ae"
  head "https://github.com/gammu/gammu.git"

  bottle do
    sha256 "e736f53af8994c489428c9fac581837e9550868d94ee44d95ceb1900523cbaab" => :sierra
    sha256 "984e40a37939c08fee6c03cd6f684750697fec6d5435a9aaece8ee10c2e6776a" => :el_capitan
    sha256 "ebcb06dd82e11742372bc18f05fa8b9c11229011d7042daca72ed01e480b4c94" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "glib" => :recommended
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBASH_COMPLETION_COMPLETIONSDIR:PATH=#{bash_completion}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"gammu", "--help"
  end
end
