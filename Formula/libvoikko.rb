class Libvoikko < Formula
  desc "Linguistic software and Finnish dictionary"
  homepage "https://voikko.puimula.org/"
  url "https://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.3.tar.gz"
  sha256 "e843df002fcea2a90609d87e4d6c28f8a0e23332d3b42979ab1793e18f839307"

  bottle do
    cellar :any
    sha256 "d2cee432c32f1c53f77f641fc40ffd80b06115b0da5cd5427e5bdfd31ca5a98d" => :catalina
    sha256 "6480599b62bb4eadfa39253c168438a2ee669945d98734b6dc5721689153c221" => :mojave
    sha256 "35dd51a52688218967b63ee1164ba56240e3ede6e8469210e50fd552e5a36aa1" => :high_sierra
  end

  depends_on "foma" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "hfstospell"

  resource "voikko-fi" do
    url "https://www.puimula.org/voikko-sources/voikko-fi/voikko-fi-2.3.tar.gz"
    sha256 "37b7886a23cfbde472715ba1266e1a81e2a87c3f5ccce8ae23bd7b38bacdcec2"
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
