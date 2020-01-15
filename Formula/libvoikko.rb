class Libvoikko < Formula
  desc "Linguistic software and Finnish dictionary"
  homepage "https://voikko.puimula.org/"
  url "https://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.3.tar.gz"
  sha256 "e843df002fcea2a90609d87e4d6c28f8a0e23332d3b42979ab1793e18f839307"
  revision 2

  bottle do
    cellar :any
    sha256 "77b2e04b116979ed93b2b6371fa434433e770b944410a55b15b2174a45ff7b8d" => :catalina
    sha256 "f9ab71db12a2457de1705ea205506efd2bacf3433a85cfecc00af01dc7430a5c" => :mojave
    sha256 "e809b2d5759f6c04c20228d91598d767462354bc4a97bcb30daa017132cd01e7" => :high_sierra
  end

  depends_on "foma" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
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
