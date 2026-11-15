class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "https://fuego.sourceforge.net/"
  url "https://github.com/mmueller65/fuego/archive/edd2392f7a87d8f1dc9b83f6a5b54a17edf20826.tar.gz"
  version "1.1"
  sha256 "85cf2fe4556847c2d48364980faf1d7a558d8170d4aea1fb1f4441819ad0b725"
  license any_of: ["GPL-3.0-only", "LGPL-3.0-only"]
  revision 17
  version_scheme 1
  head "https://svn.code.sf.net/p/fuego/code/trunk"

  livecheck do
    url "https://sourceforge.net/projects/fuego/rss?path=/fuego"
    regex(%r{url=.*?/fuego[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256               arm64_golden_gate: "0ac57f9efc9df803f73083d7b7c10e0fb5ede9d03973a3e53c454fa65bfd5bf0"
    sha256               arm64_tahoe:       "2ad5e0e31c90e52b2c6c08c966dbed5639af0ed0c6563ca490ed09838e0a1674"
    sha256               arm64_sequoia:     "82c01a4fe369b17681584dd93708c58831f496a366d8624ae68ecb1de14116d3"
    sha256               arm64_linux:       "682aaf86607f2638749a1567988634d6933474338d5aab992a5b3e71ee5839e6"
    sha256 cellar: :any, x86_64_linux:      "7d77975632ed4d15595cddf57abf2eec648d2ffe7ccc9b536cdc83733748c33a"
  end

  # Last release on 2011-03-13, last svn activity on 2019-12-10
  deprecate! date: "2026-10-17", because: :unmaintained
  disable! date: "2027-04-17", because: :unmaintained

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"

  conflicts_with "fuego-firestore", because: "both install `fuego` binaries"

  def install
    # Work around build failure with Boost 1.85.0
    # Issue ref: https://sourceforge.net/p/fuego/tickets/108/
    inreplace "fuegomain/FuegoMain.cpp", ".branch_path()", ".parent_path()"
    inreplace "smartgame/SgStringUtil.cpp", /^(\s*)(normalizedFile)\.normalize\(\);$/,
                                            "\\1\\2 = \\2.lexically_normal();"
    ENV.cxx11 # for Boost 1.92.0+

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          "--with-boost=#{formula_opt_prefix("boost")}",
                          *std_configure_args
    system "make", "install", "LIBS=-lpthread"
  end

  test do
    input = <<~EOS
      genmove white
      genmove black
    EOS
    output = pipe_output("#{bin}/fuego 2>&1", input, 0)
    assert_match(/^=\s+\w+$/, output)
    assert_match "maxgames", shell_output("#{bin}/fuego --help")
  end
end
