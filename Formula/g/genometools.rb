class Genometools < Formula
  desc "Versatile open source genome analysis software"
  homepage "https://genometools.org/"
  # genometools does not have source code on par with their binary dist on their website
  url "https://github.com/genometools/genometools/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "f71b95c84761847223cd52a17d30ad9e6d55854448c2139fcd0aac437f73fbbe"
  license "ISC"
  head "https://github.com/genometools/genometools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b77af810fa9096b084bb34232bb09883a7237ddac28d7fc35957793892a516eb"
    sha256 cellar: :any,                 arm64_ventura:  "c079e91767b29ab5b0379cc09e4ca0960717c9cfa5e580d3527696edb59a6680"
    sha256 cellar: :any,                 arm64_monterey: "fb27b879e1e52641f42f05e8ce408583e17722bddfe0e1c3f6cd677001eabc6d"
    sha256 cellar: :any,                 sonoma:         "0092f0d2c9f6ba739db151bebfa5251372d34458577b16abeba11e816ca212f7"
    sha256 cellar: :any,                 ventura:        "7e4baa8bc25ac68f65b1c2b1ea66b0e909514779d9c66bf40fca41aa4cc3cb3d"
    sha256 cellar: :any,                 monterey:       "5d93f579a6e42f7a472ece7eb28116a7b9010c4782a3f8727547f81d2684801a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da071e747525684debd137ce912248016a49ed34377020ca7a4192258ba44cc0"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "pango"
  depends_on "python@3.12"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  conflicts_with "libslax", because: "both install `bin/gt`"

  def python3
    which("python3.12")
  end

  def install
    system "make", "prefix=#{prefix}"
    system "make", "install", "prefix=#{prefix}"

    cd "gtpython" do
      # Use the shared library from this specific version of genometools.
      inreplace "gt/dlload.py",
        "gtlib = CDLL(\"libgenometools\" + soext)",
        "gtlib = CDLL(\"#{lib}/libgenometools\" + soext)"

      system python3, "-m", "pip", "install", *std_pip_args, "."
      system python3, "-m", "unittest", "discover", "tests"
    end
  end

  test do
    system bin/"gt", "-test"
    system python3, "-c", "import gt"
  end
end
