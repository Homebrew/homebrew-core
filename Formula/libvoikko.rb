class Libvoikko < Formula
  desc "Linguistic software and Finnish dictionary"
  homepage "http://voikko.puimula.org/"
  url "http://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.1.tar.gz"
  sha256 "8ecf4a352ff330594250dbc191e0843394f340061bdc6586f8ff2e281bce8e70"

  bottle do
    cellar :any
    sha256 "4e6553896c4b9590cbac1e656883755e2c33d466fb10200cd4e47e8e92c929c1" => :sierra
    sha256 "f99dcc6a225e5d8ec5227b73e05ed0fa255f665f9adfe83202855e947f3b0732" => :el_capitan
    sha256 "3184f1d1b07f2b06fc39dd424804b21a4306aeb6b648b77e4b90b00e09614ad9" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on :python3 => :build
  depends_on "foma" => :build
  depends_on "hfstospell"

  needs :cxx11

  resource "voikko-fi" do
    url "http://www.puimula.org/voikko-sources/voikko-fi/voikko-fi-2.0.tar.gz"
    sha256 "02f7595dd7e3cee188184417d6a7365f9dc653b020913f5ad75d1f14b548fafd"
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
