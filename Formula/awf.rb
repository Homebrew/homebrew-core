class Awf < Formula
  desc "'A Widget Factory' is a theme preview application for gtk2 and gtk3"
  homepage "https://github.com/valr/awf"
  url "https://github.com/valr/awf/archive/v1.4.0.tar.gz"
  sha256 "bb14517ea3eed050b3fec37783b79c515a0f03268a55dfd0b96a594b5b655c78"
  revision 2
  head "https://github.com/valr/awf.git"

  bottle do
    cellar :any
    sha256 "cb84883afc611eacadc474b10407dee6b7177758054fbc2eaa65f21ba7d96f9f" => :catalina
    sha256 "b0290ffc5c750f924cbf96a2a5398215a41137a69211d262387789e399aba9d8" => :mojave
    sha256 "090ec40bbd96bea15714d411b9c89e6b06ca9723050252f00623b49c61da1497" => :high_sierra
    sha256 "417806f1ab0aa5d1c2e2e0302dd2c3c4cdaaf2957ac18fbfe1f9a2ced72947bd" => :sierra
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
