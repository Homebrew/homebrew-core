class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2018.04.13/kakoune-2018.04.13.tar.bz2"
  sha256 "cd8ccf8d833a7de8014b6d64f0c34105bc5996c3671275b00ced77996dd17fce"

  bottle do
    sha256 "963dcb1f0cb83f49b4fca50b556299f7b817d6186cf0ccf57ace72ec465f449e" => :high_sierra
    sha256 "d49c1a22732564d9a88ec1a14edb2481840f5041abfb954fd323c6b1d4153c90" => :sierra
    sha256 "8eb380637d9d50b956b7dd7e7e46a8a789ee3743ef6a783ff885958a5337c5cb" => :el_capitan
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build

  if MacOS.version <= :el_capitan
    depends_on "gcc"
    fails_with :clang do
      build 800
      cause "New C++ features"
    end
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    cd "src" do
      system "make", "install", "debug=no", "PREFIX=#{prefix}"
    end
  end

  test do
    system bin/"kak", "-ui", "dummy", "-e", "q"
  end
end
