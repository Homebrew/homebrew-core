class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2018.10.27/kakoune-2018.10.27.tar.bz2"
  sha256 "687a173c8f94fb66aad899e7a3095fe8f08e1fdcab955dbc6785335427cc8a1d"

  bottle do
    cellar :any_skip_relocation
    sha256 "f75753c33d4e6c0061780b208bfae759900c7e981c121a46b5628ac02bd7980f" => :mojave
    sha256 "375b52230d9e13a71ad5942f0d9beafda8472ad9fcb8452b3efbcbfcb4290ecb" => :high_sierra
    sha256 "b23fc8390c4c16924434b32674b322bbc62e3b18887fef153f2569fe63acd22c" => :sierra
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
