class Genometools < Formula
  desc "Versatile open source genome analysis software"
  homepage "https://genometools.org/"
  # genometools does not have source code on par with their binary dist on their website
  url "https://github.com/genometools/genometools/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "cc5d92c44708a4566a07650bbe7e9009fb602262548427814c04d3a7043d26e9"
  license "ISC"
  head "https://github.com/genometools/genometools.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any, arm64_golden_gate: "49a0d0c8d0718c9183129c5875cdcdba4eb9d4966570bd76af5c23f76a15e0b7"
    sha256 cellar: :any, arm64_tahoe:       "05632d53beda8b77c23b66e677fd9eda9895e8f953f12757db1985d1a575feab"
    sha256 cellar: :any, arm64_sequoia:     "1bef1866c00bf15d61215426a0bdfe8de571c3a628979c3481dc637e0d4ea84c"
    sha256 cellar: :any, arm64_linux:       "f7f197e6520bd311c3388e1a16498065885054f0d84ab7a735d0b00703379c6f"
    sha256 cellar: :any, x86_64_linux:      "8d4050090629131be86cc516a70e2a388c8cbbb91d8188bef20b9d4877bceab1"
  end

  depends_on "pkgconf" => :build
  depends_on "python@3.15" => [:build, :test]
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
