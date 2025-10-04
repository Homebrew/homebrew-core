class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "https://fuego.sourceforge.net/"
  url "https://svn.code.sf.net/p/fuego/code/trunk", revision: "1981"
  version "1.1"
  license any_of: ["GPL-3.0-only", "LGPL-3.0-only"]
  revision 15
  version_scheme 1
  head "https://svn.code.sf.net/p/fuego/code/trunk"

  livecheck do
    url "https://sourceforge.net/projects/fuego/rss?path=/fuego"
    regex(%r{url=.*?/fuego[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:   "0b3ae0284526c1cd44f6eabf02ab7c6b169efceea1127b0dd4768c1bfc792f12"
    sha256                               arm64_sequoia: "dcdbfa5a927fa08abf85f0bc572d63a66e6f41cc132d9e97f6c1ede888b3d93f"
    sha256                               arm64_sonoma:  "e4458c421bde99b3e47227a6c1f700655a9bd24fed37ee3a2505b162be9112f9"
    sha256                               arm64_ventura: "e8289d17aa98ecf078bb29cd9ef32ac2cfc09635372dee6c30ea6f1d0f5ba407"
    sha256                               sonoma:        "7cd89cd4c4fc11f0f0fd069c499ee0fd0d1d4ba46e7bd52a0fc40751b03d8894"
    sha256                               ventura:       "7b34e6b51a48f1b769f14d45913846790dff6320b2cf639553d32c96c3acc749"
    sha256                               arm64_linux:   "edee126e525257ef55b5ced38ac289b06f6a2c9db6b2ee17599fc79d3175d308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d5380f0826f95049aa0f1d6e9001a1791d8fd8970902bdb2f3615aa888c1389"
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
