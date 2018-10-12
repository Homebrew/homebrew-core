class Genometools < Formula
  desc "GenomeTools: The versatile open source genome analysis software"
  homepage "http://genometools.org/"
  url "http://genometools.org/pub/genometools-1.5.10.tar.gz"
  sha256 "0208591333b74594bc219fb67f5a29b81bb2ab872f540c408ac1743716274e6a"
  revision 2
  head "https://github.com/genometools/genometools.git"

  bottle do
    cellar :any
    sha256 "89af40c5d74a8f622011c6e6dbeebebf5826492f9dbfb599f9e4a989b10d9206" => :mojave
    sha256 "3b3c2538f258f57f3d7e44e5aab06de29c3046f6269a680d251d8978545cb708" => :high_sierra
    sha256 "18204808f670a6a7f7f7281aad8dd0c26036c1d779686d0dac7faef093d81a9e" => :sierra
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
