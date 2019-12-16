class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2019.12.10/kakoune-2019.12.10.tar.bz2"
  sha256 "66ad8d28cecb29b08e5975e659ee91206ca676a0194c730ca4eed026bafa2ff8"
  head "https://github.com/mawww/kakoune.git"

  bottle do
    cellar :any
    sha256 "849e54c0a1b459741aef0572a21ee2a64e4fd5a28ea76198e44797d0f8e36e12" => :catalina
    sha256 "f4c4d121ab6deea47ffa7af2fc14185f411326a4c3e7e0f8394050fd29380f48" => :mojave
    sha256 "29683bac6ea76120d3a4f4ae6faa6cee7618b6cde34cc0765446af1ec63d0233" => :high_sierra
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
