class Libvoikko < Formula
  desc "Linguistic software and Finnish dictionary"
  homepage "http://voikko.puimula.org/"
  url "http://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.1.1.tar.gz"
  sha256 "bb179360abdb92f9459f4d4090e56c9d9d8a3ebe9161a4c4bcd19971d59f9124"

  bottle do
    cellar :any
    sha256 "2ff4c0b35ea409ef474a2f4a78a7b64569957ff1506a524a4b5c56b64e01e8e0" => :sierra
    sha256 "9a6b78f2e18306a760603b2b52743bc898a540a90e60045dc083702ccfee3a5d" => :el_capitan
    sha256 "a06bc2673259b42b4540c0cd5d0dc9c101cd161f4e6c9a557478f4c08daea25f" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on :python3 => :build
  depends_on "foma" => :build
  depends_on "hfstospell"

  needs :cxx11

  resource "voikko-fi" do
    url "http://www.puimula.org/voikko-sources/voikko-fi/voikko-fi-2.1.tar.gz"
    sha256 "71a823120a35ade6f20eaa7d00db27ec7355aa46a45a5b1a4a1f687a42134496"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-dictionary-path=#{HOMEBREW_PREFIX}/lib/voikko"
    system "make", "install"

    resource("voikko-fi").stage do
      ENV.append_path "PATH", bin.to_s
      system "make", "vvfst"
      system "make", "vvfst-install", "DESTDIR=#{lib}/voikko"
      lib.install_symlink "voikko"
    end
  end

  test do
    pipe_output("#{bin}/voikkospell -m", "onkohan\n")
  end
end
