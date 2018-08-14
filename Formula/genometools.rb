class Genometools < Formula
  desc "GenomeTools: The versatile open source genome analysis software"
  homepage "http://genometools.org/"
  url "http://genometools.org/pub/genometools-1.5.10.tar.gz"
  sha256 "0208591333b74594bc219fb67f5a29b81bb2ab872f540c408ac1743716274e6a"
  revision 1
  head "https://github.com/genometools/genometools.git"

  bottle do
    cellar :any
    sha256 "c53fb9498795701716d4d6bd57a88078d6a4167d0259dafc0cadb8a8d9507f00" => :high_sierra
    sha256 "82782fc695836444fb1077ca85705729b0f060eef912f227e958be601fe097f9" => :sierra
    sha256 "624c97f08bfad198e37fc34c02d8c3b62117023694c3a1bc8d429572e426216a" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "pango"
  depends_on "python@2"

  conflicts_with "libslax", :because => "both install `bin/gt`"

  def install
    system "make", "prefix=#{prefix}"
    system "make", "install", "prefix=#{prefix}"

    cd "gtpython" do
      # Use the shared library from this specific version of genometools.
      inreplace "gt/dlload.py",
        "gtlib = CDLL(\"libgenometools\" + soext)",
        "gtlib = CDLL(\"#{lib}/libgenometools\" + soext)"

      system "python", *Language::Python.setup_install_args(prefix)
      system "python", "-m", "unittest", "discover", "tests"
    end
  end

  test do
    system "#{bin}/gt", "-test"
    system "python2.7", "-c", "import gt"
  end
end
