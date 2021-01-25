class Genometools < Formula
  desc "Versatile open source genome analysis software"
  homepage "http://genometools.org/"
  # genometools does not have source code on par with their binary dist on their website
  url "https://github.com/genometools/genometools/archive/v1.6.1.tar.gz"
  sha256 "528ca143a7f1d42af8614d60ea1e5518012913a23526d82e434f0dad2e2d863f"
  license "ISC"
  revision 2
  head "https://github.com/genometools/genometools.git"

  bottle do
    cellar :any
    sha256 "5a78346ddcbc387c855086ddd5dc3572b03c08b37364025e99e8e3d13ef62746" => :big_sur
    sha256 "24dfec7e6f01320e9138d4f9a33bcff280238912e7394eeae02342bf2242f01c" => :arm64_big_sur
    sha256 "707d87995a1fd3153e9020630b8645f35b387ec0610950dcbcc61da8afb172e0" => :catalina
    sha256 "f2d6eba092bf144f8184ce648af3e75a2097359eda4efa7c9eabf314a30d00d1" => :mojave
    sha256 "5606993111552191b2e9215b06665bf0043c9851a6dd60c9927a32c94d0b2d4b" => :high_sierra
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
