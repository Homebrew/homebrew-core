class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "https://fuego.sourceforge.net/"
  url "https://svn.code.sf.net/p/fuego/code/trunk", revision: "1981"
  version "1.1"
  license any_of: ["GPL-3.0-only", "LGPL-3.0-only"]
  revision 16
  version_scheme 1
  head "https://svn.code.sf.net/p/fuego/code/trunk"

  livecheck do
    url "https://sourceforge.net/projects/fuego/rss?path=/fuego"
    regex(%r{url=.*?/fuego[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:   "3985560eb7b1c53182f39df987972bbcd06bd8bcd6c16eb609623a43eb19de2f"
    sha256                               arm64_sequoia: "357f8554c146ab3791a6103ba4d9729cb50828db85da47572d5522c7e954521f"
    sha256                               arm64_sonoma:  "1d1dc9eb0d6f42dc020b1832149f266405638e0ca59d3cadf53f709026e26c23"
    sha256                               sonoma:        "edb923e3b530b4a3c54c92ef05cc4166747173fdf04495e7d1ee6583e09dbf0e"
    sha256                               arm64_linux:   "7608d687864d3edb733ad68725d273f05da35477398bbcd4ada9d468e669be0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af8c62d00784576b78a9dd73f796cde7bfc29ffde66cd17c437eb3759630d013"
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

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
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
