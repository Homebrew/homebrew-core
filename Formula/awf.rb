class Awf < Formula
  desc "'A Widget Factory' is a theme preview application for gtk2 and gtk3"
  homepage "https://github.com/valr/awf"
  url "https://github.com/valr/awf/archive/v1.4.0.tar.gz"
  sha256 "bb14517ea3eed050b3fec37783b79c515a0f03268a55dfd0b96a594b5b655c78"
  license "GPL-3.0"
  revision 2
  head "https://github.com/valr/awf.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8dd0d72c50563b5651018456a9de4a274152e44627a531056eb5bf4be8bdad08"
    sha256 cellar: :any,                 arm64_big_sur:  "60373a676e554ca3b82465ff01d7bfbde233fad9e7d1ec115656903c90336a29"
    sha256 cellar: :any,                 monterey:       "1d3ff7a870c9be4280285609178cb6a9a310bd80ba76ac88efe68f2f8815917c"
    sha256 cellar: :any,                 big_sur:        "a272cb4694d49e897a17250d13b9f534bb9020189711bd982f34392e666c9b9e"
    sha256 cellar: :any,                 catalina:       "cb84883afc611eacadc474b10407dee6b7177758054fbc2eaa65f21ba7d96f9f"
    sha256 cellar: :any,                 mojave:         "b0290ffc5c750f924cbf96a2a5398215a41137a69211d262387789e399aba9d8"
    sha256 cellar: :any,                 high_sierra:    "090ec40bbd96bea15714d411b9c89e6b06ca9723050252f00623b49c61da1497"
    sha256 cellar: :any,                 sierra:         "417806f1ab0aa5d1c2e2e0302dd2c3c4cdaaf2957ac18fbfe1f9a2ced72947bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "201df4351ed6f6f8dd3da0f2ca51ca64b494ded6aac9a96489e0c41361e480fd"
  end

  deprecate! date: "2021-05-24", because: :repo_archived

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
