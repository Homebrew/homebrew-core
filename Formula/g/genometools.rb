class Genometools < Formula
  desc "Versatile open source genome analysis software"
  homepage "https://genometools.org/"
  # genometools does not have source code on par with their binary dist on their website
  url "https://github.com/genometools/genometools/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "cc5d92c44708a4566a07650bbe7e9009fb602262548427814c04d3a7043d26e9"
  license "ISC"
  head "https://github.com/genometools/genometools.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "93b7227c19b00dcfc203cd07035c587c581f50290c60d9c2c01aa8eb8243ef39"
    sha256 cellar: :any,                 arm64_sequoia: "36d3a55a5f66a64b9e0f71335057388eeb752d0fb1df95f0e723d6172d759b09"
    sha256 cellar: :any,                 arm64_sonoma:  "ab952c4fab136b0eb780b29a9bcfdfa11743dc0d89c057181a821a2a21b5d8c4"
    sha256                               sonoma:        "710d23047dbe28c95592437e8d08e9cdaed34d416f5430090354efe0f0552564"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6183d1cfa09dea81e547a747785a419753cc0c044934f96e0919c79e9858e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20bd4d59acfc6ceb6c15053a4e00494a563cfaa4a0736a18a18db2e0a73d0b08"
  end

  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "cairo"
  depends_on "glib"
  depends_on "pango"
  depends_on "tre"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "sqlite"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "gastown", "libslax", because: "both install `gt` binaries"

  def python3
    which("python3.14")
  end

  def install
    # Workaround for arm64 linux from char being unsigned.
    # Same root cause as https://github.com/genometools/genometools/issues/311
    ENV.append_to_cflags "-fsigned-char" if OS.linux? && Hardware::CPU.arm?

    # Manually unbundle as useshared=yes requires Lua 5.1 and older SAMtools
    rm_r(Dir["src/external/{bzip2,expat,sqlite,tre,zlib}*"])

    system "make", "install", "prefix=#{prefix}",
                              "ADDITIONAL_SO_DEPS=",
                              "ADDITIONAL_ZLIBS=",
                              "DEPLIBS=-lbz2 -lz -lexpat -ltre -lsqlite3",
                              "LIBBZ2_SRC=",
                              "LIBEXPAT_SRC=",
                              "LIBTRE_SRC=",
                              "OVERRIDELIBS=",
                              "SQLITE3_SRC=",
                              "ZLIB_SRC="

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
