class Genometools < Formula
  desc "GenomeTools: The versatile open source genome analysis software"
  homepage "http://genometools.org/"
  # genometools does not have source code on par with their binary dist on their website
  url "https://github.com/genometools/genometools/archive/v1.6.1.tar.gz"
  sha256 "528ca143a7f1d42af8614d60ea1e5518012913a23526d82e434f0dad2e2d863f"
  license "ISC"
  revision 1
  head "https://github.com/genometools/genometools.git"

  bottle do
    cellar :any
    sha256 "2c49e8ae31d2e3d26e90c174bb4fb1e8e007f36bd9b9508220ff321ca3520d05" => :catalina
    sha256 "c6509a3719aaa5e946f2e395c1ddcbe73c36ca8e1e965edb76136b00a3565c71" => :mojave
    sha256 "89448e5e80e60f6d62ad7cc30892ae6d67fbc7af83e8ee7ce71e232884fe6721" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "pango"
  depends_on "python@3.8"

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
    system Formula["python@3.8"].opt_bin/"python3", "-c", "import gt"
  end
end
