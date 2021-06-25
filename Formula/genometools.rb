class Genometools < Formula
  desc "Versatile open source genome analysis software"
  homepage "http://genometools.org/"
  # genometools does not have source code on par with their binary dist on their website
  url "https://github.com/genometools/genometools/archive/v1.6.2.tar.gz"
  sha256 "974825ddc42602bdce3d5fbe2b6e2726e7a35e81b532a0dc236f6e375d18adac"
  license "ISC"
  head "https://github.com/genometools/genometools.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "24dfec7e6f01320e9138d4f9a33bcff280238912e7394eeae02342bf2242f01c"
    sha256 cellar: :any, big_sur:       "5a78346ddcbc387c855086ddd5dc3572b03c08b37364025e99e8e3d13ef62746"
    sha256 cellar: :any, catalina:      "707d87995a1fd3153e9020630b8645f35b387ec0610950dcbcc61da8afb172e0"
    sha256 cellar: :any, mojave:        "f2d6eba092bf144f8184ce648af3e75a2097359eda4efa7c9eabf314a30d00d1"
    sha256 cellar: :any, high_sierra:   "5606993111552191b2e9215b06665bf0043c9851a6dd60c9927a32c94d0b2d4b"
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
