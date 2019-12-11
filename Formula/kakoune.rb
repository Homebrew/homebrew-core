class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2019.12.10/kakoune-2019.12.10.tar.bz2"
  sha256 "66ad8d28cecb29b08e5975e659ee91206ca676a0194c730ca4eed026bafa2ff8"
  head "https://github.com/mawww/kakoune.git"

  bottle do
    cellar :any
    sha256 "0cd60b373efe3e4b89576295a374405c4a3819a945c091b18e18d18de316879c" => :catalina
    sha256 "7cc097196707ad5f212b825b66f9de7f128240295fa7ccd097314c5a1145b358" => :mojave
    sha256 "755433189f53b8a410ea4659e8d9c20b26c657c4983ebd882d297118856428db" => :high_sierra
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on :macos => :high_sierra # needs C++17
  depends_on "ncurses"

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
