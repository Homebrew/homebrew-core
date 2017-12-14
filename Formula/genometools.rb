class Genometools < Formula
  desc "GenomeTools: The versatile open source genome analysis software"
  homepage "http://genometools.org/"
  url "http://genometools.org/pub/genometools-1.5.10.tar.gz"
  sha256 "0208591333b74594bc219fb67f5a29b81bb2ab872f540c408ac1743716274e6a"
  head "https://github.com/genometools/genometools.git"

  bottle do
    cellar :any
    sha256 "41b8f4a189050f98d0f78c3972d8efb095a2eea8400c486eb6d785a3f89cadae" => :high_sierra
    sha256 "b081ac73906f972a1858d86070d6d79ad3985e703f347c1fe49b0511e15e0232" => :sierra
    sha256 "06a7a3d2450c7c6538f2005d12135e8a26e2d086fc6f1d5867e9fe03fcce9833" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "pango"
  depends_on :python if MacOS.version <= :snow_leopard

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
    system "python", "-c", "import gt"
  end
end
