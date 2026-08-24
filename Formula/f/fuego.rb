class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "https://fuego.sourceforge.net/"
  url "https://svn.code.sf.net/p/fuego/code/trunk", revision: "1981"
  version "1.1"
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
    sha256               arm64_tahoe:   "b4f73b3cf1d971fb3d7d59dc767e93f0edd04f849e9587f79eb67d7c2332e6d7"
    sha256               arm64_sequoia: "db06e5eee19bf7459b5573c9739c64b45bb6232efb8367ab140ce1afce29ac78"
    sha256               arm64_sonoma:  "210784b0b6b3333aaff2b05aa3f8fdacd2882034970f6ef18ae4327b774ff944"
    sha256               sonoma:        "ce658e6cba50c132720e14dad2e6622449ab7368d3ad7aef85ced966362a9e68"
    sha256               arm64_linux:   "ce2c4cc6da7ea605087ebd5ad79260ea76cd9f5ca57f3e6af7eac8458f3276fe"
    sha256 cellar: :any, x86_64_linux:  "80308e9cf1b751c2a0956b81070ceb7f412456481c2404b5bf572887d9195b7f"
  end

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
