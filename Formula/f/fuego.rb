class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "https://fuego.sourceforge.net/"
  url "https://svn.code.sf.net/p/fuego/code/trunk", revision: "1981"
  version "1.1"
  license any_of: ["GPL-3.0-only", "LGPL-3.0-only"]
  revision 14
  version_scheme 1
  head "https://svn.code.sf.net/p/fuego/code/trunk"

  livecheck do
    url "https://sourceforge.net/projects/fuego/rss?path=/fuego"
    regex(%r{url=.*?/fuego[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sequoia: "93d2ddf5cfa10cbe4c169d575233cbb5a70a19ce9f35c8d9564f2c73109d5d46"
    sha256                               arm64_sonoma:  "3a5678963983758b8313726c5d0dfbff571034bef93268d66e9c6563587f2854"
    sha256                               arm64_ventura: "89334b62eb393f5eac331ae536d28edca845cfd3f45db569f12f66c2db1e39f9"
    sha256                               sonoma:        "577ff959269a98802a0ef45f93434f52e8190788f0735187b15522f43a00bfb8"
    sha256                               ventura:       "4396270f30be34d07fc13b3295e37652aa33b078e6b85d68960995fc73bba5fe"
    sha256                               arm64_linux:   "2419b0d365e205a121f81b071e9598436ad2090efe0b7168048a84a991b7bd81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "085f90f29e048c4f70a995c2c17d9b972649f7375b15f29b5d1b94efeededae8"
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
