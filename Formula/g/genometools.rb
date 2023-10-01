class Genometools < Formula
  desc "Versatile open source genome analysis software"
  homepage "http://genometools.org/"
  # genometools does not have source code on par with their binary dist on their website
  url "https://github.com/genometools/genometools/archive/v1.6.3.tar.gz"
  sha256 "b4919a2eafaa353a69ff4e63c788faeaa95b61bdf8d6e70e9922e0c955e95ff8"
  license "ISC"
  head "https://github.com/genometools/genometools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "97607396979f466778e984c7bcd94185ce30001a048b6fa8f96ffad22228937d"
    sha256 cellar: :any,                 arm64_monterey: "202585029e5162f1ce5f11818e9b32d8ab95ef6ad5cec674aa9de94433a11be4"
    sha256 cellar: :any,                 arm64_big_sur:  "886b8dd879920740b132eb0a93f19fece65b7a5db31b57eaa0ddfbd46d592c77"
    sha256 cellar: :any,                 ventura:        "391c859fbb173886b6cd5697587365a4b7c9cc3a3539eae31a1a78ded70557b5"
    sha256 cellar: :any,                 monterey:       "2892b580fc796ec287f7643dfdf8b494acf9e3cc93aa7d8b19c9302bce686d1b"
    sha256 cellar: :any,                 big_sur:        "2bd803ad38d8d31691d97fe671cc6035f31e1a802bde3df53623635b9915d1bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74ee2ff428a5b73882e5870ae44726ca311d84551fb5319f908b8a82b9fd96e0"
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
