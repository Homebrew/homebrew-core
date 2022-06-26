class Cracklib < Formula
  desc "LibCrack password checking library"
  homepage "https://github.com/cracklib/cracklib"
  url "https://github.com/cracklib/cracklib/releases/download/v2.9.7/cracklib-2.9.7.tar.bz2"
  sha256 "fe82098509e4d60377b998662facf058dc405864a8947956718857dbb4bc35e6"
  license "LGPL-2.1"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6c9f2d8a461d48c833fb9e3f1df5f394efb5512bb851f113aee02be62347efb2"
    sha256 cellar: :any,                 arm64_big_sur:  "ffc09f71e17accfb3b76513b8fe6220aa683bfce4132e182eaa8e47993f9d3df"
    sha256 cellar: :any,                 monterey:       "9ecd3347d1d4020526434c540c6afda0b71863d0b7edf1ba3d8c61fcebaae38c"
    sha256 cellar: :any,                 big_sur:        "308feca305163e5333e84e3fbbfa497c0b483b13f99ed62971e1d503dd137150"
    sha256 cellar: :any,                 catalina:       "6b22a44df4e1602edc9d248bd1ef58a638c1d04cfdfcbc745f331d05ea91d8ac"
    sha256 cellar: :any,                 mojave:         "cdf8e3240e77e574df95271024c7b260ef5eafea27dfa6f6188c1a686dd1b9be"
    sha256 cellar: :any,                 high_sierra:    "210b950eee847fdccdb388c14d87eb425182282e581187302daa91dfa166fb78"
    sha256 cellar: :any,                 sierra:         "3e74c66c810e5faa99833fc89d375945d0059ddc4b13b5f57128de70cff9dfef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "453522bad648a4fe745e92c977ba9b5810c1246aeb9ba12efa81ac8680fc137a"
  end

  depends_on "gettext"

  resource "cracklib-words" do
    url "https://github.com/cracklib/cracklib/releases/download/v2.9.7/cracklib-words-2.9.7.bz2"
    sha256 "ec25ac4a474588c58d901715512d8902b276542b27b8dd197e9c2ad373739ec4"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--without-python",
                          "--with-default-dict=#{var}/cracklib/cracklib-words"
    system "make", "install"

    share.install resource("cracklib-words")
  end

  def post_install
    (var/"cracklib").mkpath
    cp share/"cracklib-words-#{version}", var/"cracklib/cracklib-words"
    system "#{bin}/cracklib-packer < #{var}/cracklib/cracklib-words"
  end

  test do
    assert_match "password: it is based on a dictionary word", pipe_output("#{bin}/cracklib-check", "password", 0)
  end
end
