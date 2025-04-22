class Genometools < Formula
  desc "Versatile open source genome analysis software"
  homepage "https://genometools.org/"
  # genometools does not have source code on par with their binary dist on their website
  url "https://github.com/genometools/genometools/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "f71b95c84761847223cd52a17d30ad9e6d55854448c2139fcd0aac437f73fbbe"
  license "ISC"
  head "https://github.com/genometools/genometools.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "c1a9595a2911398dab4d2b22c2b0182e1cf5b83f5c648ba3e61787ac9a2f9250"
    sha256 cellar: :any,                 arm64_sonoma:  "fada49496d68c5b3270ca9a075e7ea313eeb9c9bdaa263e3f16d12b3cb087b69"
    sha256 cellar: :any,                 arm64_ventura: "a6ee8e5efc50803249afd3d9eb483e48f0008840800075aa1ab3a382b3800fad"
    sha256 cellar: :any,                 sonoma:        "a04778fc4c9cb45a2b8f728527e3d865f653c1674f19c1972ef8d1144afdb955"
    sha256 cellar: :any,                 ventura:       "14a0b5028decdfcc90c0d3220cbe2b48880e346509a05507bb0dabbefa91a9f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd73938ff6ed8d07d1d3e028ff9b198e3439b7987daf61dd92c68b4c744926e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c570e15eef30b96b5ae3e6e398097589d6c8f9827a0694835071026e2793b3cf"
  end

  depends_on "pkgconf" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "cairo"
  depends_on "glib"
  depends_on "pango"
  depends_on "tre"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  conflicts_with "libslax", because: "both install `bin/gt`"

  def python3
    which("python3.13")
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
