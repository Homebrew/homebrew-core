class Genometools < Formula
  desc "Versatile open source genome analysis software"
  homepage "https://genometools.org/"
  # genometools does not have source code on par with their binary dist on their website
  url "https://github.com/genometools/genometools/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "f71b95c84761847223cd52a17d30ad9e6d55854448c2139fcd0aac437f73fbbe"
  license "ISC"
  head "https://github.com/genometools/genometools.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "da1c94350cca5fa3b665086a411fb4ed8cc5688ae2481634bb0247f8cdaa27e4"
    sha256 cellar: :any,                 arm64_sonoma:  "d02b971ab006caed47c9684c217f2a7c7e71989acbc7747032041c71255da092"
    sha256 cellar: :any,                 arm64_ventura: "0c63a6b823fb704a5b1b770576af562524cb4330efb2ab95ef00193cc8a0558c"
    sha256 cellar: :any,                 sonoma:        "fcb8877202b8dbf18e12fe4dbca2a4cadbdcae3003b969cc747859be14d0e0cd"
    sha256 cellar: :any,                 ventura:       "c7793a7fffe811824e76f17669d35189e7ddb96273e8e6fca0ceeb7b9ee905df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38195c0605998af265648a4c1efb0804987c6505110a0db321dd14512480b46d"
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "pango"
  depends_on "python@3.13"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  conflicts_with "libslax", because: "both install `bin/gt`"

  def python3
    which("python3.13")
  end

  def install
    system "make", "prefix=#{prefix}"
    system "make", "install", "prefix=#{prefix}"

    cd "gtpython" do
      # Use the shared library from this specific version of genometools.
      inreplace "gt/dlload.py",
        "gtlib = CDLL(\"libgenometools\" + soext)",
        "gtlib = CDLL(\"#{lib}/libgenometools\" + soext)"

      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
      system python3, "-m", "unittest", "discover", "tests"
    end
  end

  test do
    system bin/"gt", "-test"
    system python3, "-c", "import gt"
  end
end
