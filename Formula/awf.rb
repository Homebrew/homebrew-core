class Awf < Formula
  desc "'A Widget Factory' is a theme preview application for gtk2 and gtk3"
  homepage "https://github.com/valr/awf"
  url "https://github.com/valr/awf/archive/v1.4.0.tar.gz"
  sha256 "bb14517ea3eed050b3fec37783b79c515a0f03268a55dfd0b96a594b5b655c78"
  revision 1
  head "https://github.com/valr/awf.git"

  bottle do
    cellar :any
    sha256 "d64d7cc69ccc6bfab256afed30c89d7ce25234ada80afd33475bba4b7263b163" => :mojave
    sha256 "50dae601b8135cc9bb01e62c4268812f5c6cc935f0c326e0e66cdc66a3337186" => :high_sierra
    sha256 "6685282a4c03f247e2e619bd4ba4b531c73e867f34708def93cdc13fc3e9ec7b" => :sierra
    sha256 "18761ce847fb96be9dbf1339a683ce65695a76c1e3508d2f3f6d60cb80218481" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "gtk+3"

  def install
    inreplace "src/awf.c", "/usr/share/themes", "#{HOMEBREW_PREFIX}/share/themes"
    system "./autogen.sh"
    rm "README.md" # let's not have two copies of README
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_predicate bin/"awf-gtk2", :exist?
    assert_predicate bin/"awf-gtk3", :exist?
  end
end
