class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "https://fuego.sourceforge.net/"
  url "https://svn.code.sf.net/p/fuego/code/trunk", revision: "1981"
  version "1.1"
  license any_of: ["GPL-3.0-only", "LGPL-3.0-only"]
  revision 13
  version_scheme 1
  head "https://svn.code.sf.net/p/fuego/code/trunk"

  livecheck do
    url "https://sourceforge.net/projects/fuego/rss?path=/fuego"
    regex(%r{url=.*?/fuego[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sequoia: "13e5216438f83d46c8ee563d374ce2d1779d939e3685ddfb8dbadc4e80973603"
    sha256                               arm64_sonoma:  "6e990c366d2f9336021ece74d5e1631138494956102841e5e604a6b191c1f835"
    sha256                               arm64_ventura: "e46f29878cd3da3bd37ea45ed0b059d6107614db694ab42cdae6aab8e9300fb7"
    sha256                               sonoma:        "e386d89a79e0a445169ad537a6c0355470cc627eb8dff028e63683fdb87faf4c"
    sha256                               ventura:       "17498a162c38903e19def645d699200834edd0257faaffa506f4270bc53628b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a636b9b22b178bf38ad82e3c488b5decc87d7124c254e3f7a16cc37bfc642cf1"
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
