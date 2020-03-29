class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2020.01.16/kakoune-2020.01.16.tar.bz2"
  sha256 "a094f1689f0228308f631e371b382b0c0522391fc8b6c23a6cbc71ff404a0dae"
  head "https://github.com/mawww/kakoune.git"

  bottle do
    cellar :any
    sha256 "d3b04db4808b72c01136283294fee71a4a9208b12960d01d4f723be63e2c063c" => :catalina
    sha256 "6704180fb31e7f274185553876c4f84d730e2f0ddf1ae152103237207baf5a59" => :mojave
    sha256 "df9167e16c2f1b8fbca85511b47dd56c74b096b7acfd6e95f2215c2078d6902b" => :high_sierra
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on :macos => :high_sierra # needs C++17
  depends_on "ncurses"

  uses_from_macos "libxslt" => :build

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
