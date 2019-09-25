class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2019.07.01/kakoune-2019.07.01.tar.bz2"
  sha256 "8cf978499000bd71a78736eaee5663bd996f53c4e610c62a9bd97502a3ed6fd3"
  head "https://github.com/mawww/kakoune.git"

  bottle do
    cellar :any
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
