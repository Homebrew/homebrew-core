class Arabica < Formula
  desc "XML toolkit written in C++"
  homepage "https://www.jezuk.co.uk/tags/arabica.html"
  url "https://github.com/jezhiggins/arabica/archive/2020-April.tar.gz"
  version "20200425"
  sha256 "b00c7b8afd2c3f17b5a22171248136ecadf0223b598fd9631c23f875a5ce87fe"
  license "BSD-3-Clause"
  head "https://github.com/jezhiggins/arabica.git"

  bottle do
    cellar :any
    sha256 "4fbf676c46941de213b095ab74f0b4973e5984c2bbaa7679757b0db4b369480a" => :catalina
    sha256 "acc299016dbd644658880e9fa29af6d3f0b9f8e226b16ccd3fcaea8dae23febf" => :mojave
    sha256 "62920d4f26c2da71c6abf60c90c1322457e340df8142d7133a9ee1f7c2b46745" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost"

  uses_from_macos "expat"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/mangle")
    assert_match "mangle is an (in-development) XSLT processor", output
  end
end
