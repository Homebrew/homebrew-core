class Odt2txt < Formula
  desc "Convert OpenDocument files to plain text"
  homepage "https://github.com/dstosberg/odt2txt/"
  url "https://github.com/dstosberg/odt2txt/archive/v0.5.tar.gz"
  sha256 "23a889109ca9087a719c638758f14cc3b867a5dcf30a6c90bf6a0985073556dd"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "31e17f05898b06469cbc33244f357c61baf059120e96b34d472325e38adfa4d7" => :catalina
    sha256 "eb4ea913c8c1f5108adae12acf43ada9033c3bdd2e6976fcce9726108b47df2b" => :mojave
    sha256 "02dd0957fda7e5845824951a3e98d2ac9a1a623a02709631d26496bbe0353dee" => :high_sierra
    sha256 "88fb433f9e72c6c727f9af5ff017d6bac07f29bc64bfa59f6b53d4ab52f42cb3" => :sierra
    sha256 "4b86c07be0d96899d76adee3bf65390beb4288eeddbfb531dfcdbc3f17ff5bc8" => :el_capitan
    sha256 "2005cd3ccfc24aa3c188339a63d48454636ace229cffc6b2add8ecf05eea40a1" => :yosemite
  end

  resource "sample" do
    url "https://github.com/Turbo87/odt2txt/raw/samples/samples/sample-1.odt"
    sha256 "78a5b17613376e50a66501ec92260d03d9d8106a9d98128f1efb5c07c8bfa0b2"
  end

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    resources.each do |r|
      r.fetch
      system "#{bin}/odt2txt", r.cached_download
    end
  end
end
