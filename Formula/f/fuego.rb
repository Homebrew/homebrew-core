class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "https://fuego.sourceforge.net/"
  url "https://svn.code.sf.net/p/fuego/code/trunk", revision: "1981"
  version "1.1"
  license any_of: ["GPL-3.0-only", "LGPL-3.0-only"]
  revision 12
  version_scheme 1
  head "https://svn.code.sf.net/p/fuego/code/trunk"

  livecheck do
    url "https://sourceforge.net/projects/fuego/rss?path=/fuego"
    regex(%r{url=.*?/fuego[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sequoia:  "ba5cd9af8fe11684d0dfffcd393417b2874849666cbe77cfcfde03d461074d5f"
    sha256                               arm64_sonoma:   "728de8edc4b06d36d3160d14071d41a398d7baf7a25e7d549d58ab577acce36e"
    sha256                               arm64_ventura:  "5e8cc9ada632b70b903ddcbf541dc53a2f32382108000988c5c8314c931a37a2"
    sha256                               arm64_monterey: "44f70fc2fc2c52d9cbe6c58cf66a1d707e9f4e8625d3f168c583dd2a5c1efbd4"
    sha256                               sonoma:         "39cbea7e8175ec689dccb15259cceba74e74e0886092067b2f3792a5a2b63aed"
    sha256                               ventura:        "0d50385a7d97bd9972812775a070f4d1439ff222507e17ffbf3bc06467751a62"
    sha256                               monterey:       "4a91c2ccaa69c0b765c61f9a77185e652190d2b1576419d38fb67cbd21090e0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a413e72174860b5211d482c1a1b1e69ecd90ff314236c86dbc1f3287aeaa7f6"
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
