class Genometools < Formula
  desc "Versatile open source genome analysis software"
  homepage "http://genometools.org/"
  # genometools does not have source code on par with their binary dist on their website
  url "https://github.com/genometools/genometools/archive/v1.6.4.tar.gz"
  sha256 "eda9cf3a5d63e5017f3c315c5700b0e308c08793d5795bc889350a536369a449"
  license "ISC"
  head "https://github.com/genometools/genometools.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "4735666536bc7081bae338bebf4e9415ae9881826cce4dc63cdd49930b8cb472"
    sha256 cellar: :any,                 arm64_ventura:  "b28f195383ed189e24b78057c0dcc62f792a39a681f47930763e0e163ce9744c"
    sha256 cellar: :any,                 arm64_monterey: "0c3f0e9c6ddfb69b78b08425a863f2b2a80d63f86c928cd52aed5ae04e038727"
    sha256 cellar: :any,                 sonoma:         "832ad65e5843c6bbdf75c8948c7be18dd263604299cae01a46f7e7a8f2627a9e"
    sha256 cellar: :any,                 ventura:        "a8c34cdb1af7e0e93fd36be1e187b84a8f2d576a6bcddd8b58eb34c0f7dabcd8"
    sha256 cellar: :any,                 monterey:       "5cc81847071662320ac79444fc76e040c2f9abbcaeaba7b31da3ce1a4efa0e2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ecb5b123239bf914c042628f716803e92a8ce3790a6da3292205014e0068326"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "cairo"
  depends_on "pango"
  depends_on "python@3.12"

  on_linux do
    depends_on "libpthread-stubs" => :build
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
