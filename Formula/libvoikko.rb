class Libvoikko < Formula
  desc "Linguistic software and Finnish dictionary"
  homepage "https://voikko.puimula.org/"
  url "https://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.2.tar.gz"
  sha256 "f13c59825f36152f388cd96f638e447744199775277f4e6bcd0b9483f0eebeca"
  revision 1

  bottle do
    cellar :any
    sha256 "5620d97e8cc678f3b3d587c4b823c97973728270e3d7ca9bc271ede33460adfc" => :mojave
    sha256 "d1364046f46fd563531bf49ea5e323bfa587dc52690d44a426761523ad0ca969" => :high_sierra
    sha256 "cf6af0c8bd59eb76d42ab774f2b8492f10e6346f5d13203adaea2a2482c913d9" => :sierra
  end

  depends_on "foma" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "hfstospell"

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
