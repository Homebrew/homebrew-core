class Genometools < Formula
  desc "GenomeTools: The versatile open source genome analysis software"
  homepage "http://genometools.org/"
  url "http://genometools.org/pub/genometools-1.5.10.tar.gz"
  sha256 "0208591333b74594bc219fb67f5a29b81bb2ab872f540c408ac1743716274e6a"
  revision 3
  head "https://github.com/genometools/genometools.git"

  bottle do
    cellar :any
    sha256 "015822f99146040c6a5330bf99d3ae3be3802388362483058943ccf50e798f69" => :mojave
    sha256 "85f0a2692a6f93089bc2a1a7967f7d410b99b55a9536db8a3191008999b17e4b" => :high_sierra
    sha256 "e7a8e2ae40f1b5fb56e09e0449fefc10f00b820fe333d9f8fb2ed19ad92ebce1" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "pango"
  depends_on "python"

  conflicts_with "libslax", :because => "both install `bin/gt`"

  def install
    system "make", "prefix=#{prefix}"
    system "make", "install", "prefix=#{prefix}"

    cd "gtpython" do
      # Use the shared library from this specific version of genometools.
      inreplace "gt/dlload.py",
        "gtlib = CDLL(\"libgenometools\" + soext)",
        "gtlib = CDLL(\"#{lib}/libgenometools\" + soext)"

      system "python3", *Language::Python.setup_install_args(prefix)
      system "python3", "-m", "unittest", "discover", "tests"
    end
  end

  test do
    system "#{bin}/gt", "-test"
    system "python3", "-c", "import gt"
  end
end
