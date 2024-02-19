class GtkChtheme < Formula
  desc "GTK+ 2.0 theme changer GUI"
  homepage "http://plasmasturm.org/code/gtk-chtheme/"
  url "http://plasmasturm.org/code/gtk-chtheme/gtk-chtheme-0.3.1.tar.bz2"
  sha256 "26f4b6dd60c220d20d612ca840b6beb18b59d139078be72c7b1efefc447df844"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fd993a95f52231aac2acb71aa478d443562516a2e8df9ee17c59a102dcb954b8"
    sha256 cellar: :any,                 arm64_ventura:  "5b0a66205d00b377659f777db9aa0196af0ba64519bcd759ba7bc9da55afb37e"
    sha256 cellar: :any,                 arm64_monterey: "a6b9e2b55273be2bbfe8b54a82757e22c4a19e45a1f63780500499e73393d408"
    sha256 cellar: :any,                 arm64_big_sur:  "8db79039412079abddb969b631131eb3a85f4e90edbcda84bffe4505e55f44b7"
    sha256 cellar: :any,                 sonoma:         "68c360cf0af1ac7cc7bf9910daaa86996825131e58579fc872c094fb479ca672"
    sha256 cellar: :any,                 ventura:        "98eeaded4eeae18b8aab5b9a91a8063facaa044a62cdfa7ad0afeaa15cad6259"
    sha256 cellar: :any,                 monterey:       "b5f53c47bbe67239f626bd71f2c19e3d1327b232a089bf9a6989e2cb8b1eebc2"
    sha256 cellar: :any,                 big_sur:        "b6255d461ea8c2ce6606170fdfc3d0564cc7d83ad5feeb7243c6dac01a7ba9e1"
    sha256 cellar: :any,                 catalina:       "6294abe2d8ad07c52cc78c6fd156fba145340c163d4be7d103ce91ef84d2911b"
    sha256 cellar: :any,                 mojave:         "54438d348c8534071e384f17ce9e9e5e784ec9732b64249a996372360edb5f9a"
    sha256 cellar: :any,                 high_sierra:    "5e3ddc7b15e6d35d857815932e80b39f0abf804c8526cc798f0b3d3d66fe0338"
    sha256 cellar: :any,                 sierra:         "5af49da12ab0e1799377eb160cff68283b7a24e0149135603d35810e6c0d7e55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b7b31e4dee87e90caa847fadfb056eb44f063a6903528eeb3238ab6a78b8ca9"
  end

  # GTK 2 is EOL: https://blog.gtk.org/2020/12/16/gtk-4-0/
  # No new release or commit since 2008
  disable! date: "2024-01-21", because: :unmaintained

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+"

  def install
    # Unfortunately chtheme relies on some deprecated functionality
    # we need to disable errors for it to compile properly
    inreplace "Makefile", "-DGTK_DISABLE_DEPRECATED", ""

    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    inreplace "Makefile", "$(LDFLAGS) $^", "$^ $(LDFLAGS)" unless OS.mac?

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    # package contains just an executable and a man file
    # executable accepts no options and just spawns a GUI
    assert_predicate bin/"gtk-chtheme", :exist?
  end
end
