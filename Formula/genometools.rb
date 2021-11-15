class Genometools < Formula
  desc "Versatile open source genome analysis software"
  homepage "http://genometools.org/"
  # genometools does not have source code on par with their binary dist on their website
  url "https://github.com/genometools/genometools/archive/v1.6.2.tar.gz"
  sha256 "974825ddc42602bdce3d5fbe2b6e2726e7a35e81b532a0dc236f6e375d18adac"
  license "ISC"
  head "https://github.com/genometools/genometools.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "08242bc47368b56715af9ff71c75e61bf65d1b74e545007b53411a85c286dd2c"
    sha256 cellar: :any,                 arm64_big_sur:  "1bdde783ed231c4a60b1b9b1ca43e1ad1115140a83c98ed8b709bd1a9c73d011"
    sha256 cellar: :any,                 monterey:       "5806462e96ba7622cc672e8179c42ec153c99e231032ae1d30d6671cab1cca9d"
    sha256 cellar: :any,                 big_sur:        "8adf70e333da419e3ee99a7da16c72c32cd2b03584bf0210d69ee7dcb3106d63"
    sha256 cellar: :any,                 catalina:       "41a9e52f2f0853eb1826e7136a43ae17410292fdc277860eef8f56980f124572"
    sha256 cellar: :any,                 mojave:         "606831c946666247431971c496c9d028434c04537a4cbf67f9965a83508f54d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6007cc8d2b711a4a49af59d58bfc18478f837635a2de07c85c9ef73fdafc521e"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "pango"
  depends_on "python@3.9"

  on_linux do
    depends_on "libpthread-stubs" => :build
  end

  conflicts_with "libslax", because: "both install `bin/gt`"

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
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import gt"
  end
end
