class Genometools < Formula
  desc "Versatile open source genome analysis software"
  homepage "http://genometools.org/"
  # genometools does not have source code on par with their binary dist on their website
  url "https://github.com/genometools/genometools/archive/v1.6.2.tar.gz"
  sha256 "974825ddc42602bdce3d5fbe2b6e2726e7a35e81b532a0dc236f6e375d18adac"
  license "ISC"
  revision 1
  head "https://github.com/genometools/genometools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b09bb366e3e15f77d94aab5e6bdb072e9304534245a730783df426deccfe040a"
    sha256 cellar: :any,                 arm64_big_sur:  "f350d9c4cac62bcb0b3de1153d4f2fd760b529f02bd9a43f21c91ecfa5e0b47b"
    sha256 cellar: :any,                 monterey:       "27d16515d739177e10547d62c76b0b20af221979572f05982d3a37392bf52dcd"
    sha256 cellar: :any,                 big_sur:        "b97131de84349e7e805095564ba995eb6d06e99b8e0f9b4f5b943e42af17997e"
    sha256 cellar: :any,                 catalina:       "4b59bf76b39c797a21e6cd2acb90fdf273316ff73cd3c97ede296f672493a42a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ee8f9d26f65607d15f8113c45c9ccf670fd01a9d12e4ca764d9ee3a0e4705b1"
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
