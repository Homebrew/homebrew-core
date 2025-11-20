class Genometools < Formula
  desc "Versatile open source genome analysis software"
  homepage "https://genometools.org/"
  # genometools does not have source code on par with their binary dist on their website
  url "https://github.com/genometools/genometools/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "cc5d92c44708a4566a07650bbe7e9009fb602262548427814c04d3a7043d26e9"
  license "ISC"
  head "https://github.com/genometools/genometools.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a18a88f6b025c750cfba1db4bea79eddfbb06842b43a1438974c2abda0a7db93"
    sha256 cellar: :any,                 arm64_sequoia: "e3e6f65acd7d877ff6767a1d938c679a2a3f620933d3bb85730659fdf5e2d353"
    sha256 cellar: :any,                 arm64_sonoma:  "b6256750e50b2b3c98dc8ba4ddd1f3b937992a8dd0a39af142016d5bf01f0462"
    sha256                               sonoma:        "426c5f4b996dec03dffb8aa2d976ba4b70487761ae4a79da21fccf0513fd637f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41927af5e909bb8d70eed0e7ddeaa937c60eb0f677446bafe9fe15b97f3091f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae0fa607f8920e689ce456d9639179f090dc245dcd0cf7d59088acea42bfc5d5"
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
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  conflicts_with "libslax", because: "both install `bin/gt`"

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
