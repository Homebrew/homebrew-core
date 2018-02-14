class Libvoikko < Formula
  desc "Linguistic software and Finnish dictionary"
  homepage "http://voikko.puimula.org/"
  url "https://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.1.1.tar.gz"
  sha256 "bb179360abdb92f9459f4d4090e56c9d9d8a3ebe9161a4c4bcd19971d59f9124"
  revision 1

  bottle do
    cellar :any
    sha256 "33c8fc6bc91efd0288cbc470b7c39aa2a9ab47dcfc75a5f7d09ccd493411eafb" => :high_sierra
    sha256 "7f734e1e1b0e20858d744b654975c403679ba3833cae41f5214c4e5ae31e4847" => :sierra
    sha256 "8ce41d927ef6b6cc3e27bfd40bb898efeb069c2314ac9d9a2b349246ec0165e6" => :el_capitan
    sha256 "b0f9d5753691aa1af8bb864f5b3ca8cc753da9e2dfdf47f4dad98394f2201811" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "python3" => :build
  depends_on "foma" => :build
  depends_on "hfstospell"

  needs :cxx11

  resource "voikko-fi" do
    url "https://www.puimula.org/voikko-sources/voikko-fi/voikko-fi-2.1.tar.gz"
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
