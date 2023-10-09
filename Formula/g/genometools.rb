class Genometools < Formula
  desc "Versatile open source genome analysis software"
  homepage "http://genometools.org/"
  # genometools does not have source code on par with their binary dist on their website
  url "https://github.com/genometools/genometools/archive/v1.6.4.tar.gz"
  sha256 "eda9cf3a5d63e5017f3c315c5700b0e308c08793d5795bc889350a536369a449"
  license "ISC"
  head "https://github.com/genometools/genometools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2a7b4c90ad72907cff0ee0f1f52dff1cd792e59ee82860ba6688df53d2a862c6"
    sha256 cellar: :any,                 arm64_ventura:  "8c161bad28feb7c19ab0d56b2719aa56e98f25280780f3ce1d1cbc040f1effe6"
    sha256 cellar: :any,                 arm64_monterey: "0cefb090268b9b713f4a9588af91df54eb5c64a49085c5e5e1ca76feaae311f9"
    sha256 cellar: :any,                 sonoma:         "fe42ae0af02c4ee6d6d0ad913b9037ffafce25be3985ba228665f07055a045aa"
    sha256 cellar: :any,                 ventura:        "1f3db34b829b97b31d2ce7c18f25ee0a23aea9f69c93165656492b4eebebed11"
    sha256 cellar: :any,                 monterey:       "234512e3a4d4b6c398acdc3aeb7032eaee6c5486a76a0bf9568915c9e1d54821"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4819b7a02bcbbe1fa461661347da16f31d7b72db29e177dda16e0293bb30f014"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "pango"
  depends_on "python@3.10"

  on_linux do
    depends_on "libpthread-stubs" => :build
  end

  conflicts_with "libslax", because: "both install `bin/gt`"

  def python3
    "python3.10"
  end

  def install
    system "make", "prefix=#{prefix}"
    system "make", "install", "prefix=#{prefix}"

    cd "gtpython" do
      # Use the shared library from this specific version of genometools.
      inreplace "gt/dlload.py",
        "gtlib = CDLL(\"libgenometools\" + soext)",
        "gtlib = CDLL(\"#{lib}/libgenometools\" + soext)"

      system python3, *Language::Python.setup_install_args(prefix, python3)
      system python3, "-m", "unittest", "discover", "tests"
    end
  end

  test do
    system "#{bin}/gt", "-test"
    system python3, "-c", "import gt"
  end
end
