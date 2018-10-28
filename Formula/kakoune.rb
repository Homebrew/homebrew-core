class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2018.10.27/kakoune-2018.10.27.tar.bz2"
  sha256 "687a173c8f94fb66aad899e7a3095fe8f08e1fdcab955dbc6785335427cc8a1d"

  bottle do
    cellar :any_skip_relocation
    sha256 "7580f7a2fd238383ce36bdc887714e7b445f0128c140387d4fccd5a3c2b6ead9" => :mojave
    sha256 "28627f60d6207db2bf610dcd63ea9c9ed719742a321f24e942a72417d6063aea" => :high_sierra
    sha256 "9531f7402473a184da3fe11c6b540f07eba5e2969aca02131ec9921b8f8d7049" => :sierra
    sha256 "7b1d503559b3ebcf5a2e5a8c34db77391ebd5c47b8cf9fcf47ecb0893fbda2f3" => :el_capitan
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
