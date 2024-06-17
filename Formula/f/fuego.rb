class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "https://fuego.sourceforge.net/"
  url "https://svn.code.sf.net/p/fuego/code/trunk", revision: "1981"
  version "1.1"
  license any_of: ["GPL-3.0-only", "LGPL-3.0-only"]
  revision 11
  version_scheme 1
  head "https://svn.code.sf.net/p/fuego/code/trunk"

  livecheck do
    url "https://sourceforge.net/projects/fuego/rss?path=/fuego"
    regex(%r{url=.*?/fuego[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "4efea019ce107615d44cb7e953b9cb8cb1a75ad64247cb0a62f9a7a821e02d65"
    sha256                               arm64_ventura:  "d93f77ed5fe2e7e6f68dcedd67453d5648c3f47485b594815b712bf383042f40"
    sha256                               arm64_monterey: "0a5a466446e91d45f7be39b5a6e0e9973a9875cc585ba47d48b5cad1bc61b03f"
    sha256                               sonoma:         "f911631864a16c00781379c907d725e38098e5f5894dba700093af6eb3b8437b"
    sha256                               ventura:        "a49aeab701ca4152243dfcc2bbe3833945b3599e6d26f623c0155884609c80cd"
    sha256                               monterey:       "e0ce16f58174e8fc0e23ab87683d42988f9054b7a8f19aa6a1abf4d0ea1e9ecb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61f2f5e9664488211903b1883f92c9a9c18905095a0d15b3a1be81507fbbc0d5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"

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
