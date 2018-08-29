class Pdfsandwich < Formula
  desc "Generate sandwich OCR PDFs from scanned file"
  homepage "http://www.tobias-elze.de/pdfsandwich/"
  url "https://downloads.sourceforge.net/project/pdfsandwich/pdfsandwich%200.1.7/pdfsandwich-0.1.7.tar.bz2"
  sha256 "9795ffea84b9b6b501f38d49a4620cf0469ddf15aac31bac6dbdc9ec1716fa39"
  head "https://svn.code.sf.net/p/pdfsandwich/code/trunk/src"

  bottle do
    cellar :any_skip_relocation
    sha256 "48824ed025286aa303ed5b97773a7950911b9960451fda4b4fb6507d840f0add" => :mojave
    sha256 "c9d15595a1464fef2f81fb8407341ade62ad10d0e0c0f02f89a20d0b68fbb55f" => :high_sierra
    sha256 "ed31bc5b7ab23423ae7e94fa26152ae0313061ec5bdfcc2f0cbeaf2a778fa323" => :sierra
    sha256 "2360d92a613c69b69a4b20cc13b081d333c8ee9a48311ffd41ff8a036bc9fcff" => :el_capitan
  end

  depends_on "gawk" => :build
  depends_on "ocaml" => :build
  depends_on "exact-image"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "poppler"
  depends_on "tesseract"
  depends_on "unpaper"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    bin.env_script_all_files(libexec/"bin", :PATH => "#{Formula["poppler"].opt_bin}:$PATH")
  end

  test do
    # Cannot test more than this without removing our default security
    # policy for Imagemagick, which this formula isn't popular enough
    # to justify doing.
    assert_match version.to_s, shell_output("#{bin}/pdfsandwich -version")
  end
end
