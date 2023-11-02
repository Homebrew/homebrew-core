class Pan < Formula
  desc "Usenet newsreader that's good at both text and binaries"
  homepage "https://pan.rebelbase.com"
  url "https://gitlab.gnome.org/GNOME/pan/-/archive/v0.155/pan-v0.155.tar.bz2"
  sha256 "3624ac3171fa8089825ce55b62b053db4f86d592f717c4d874c48ce0e885dff2"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "4ca4f98c9d8b4b1fb18019135f6a71cbd332e926d0460f3b788998a50ac3fde7"
    sha256 arm64_ventura:  "b67ea740c7a1d737d8d9bc20928e45d95d943f7ffee9d4a5af46ac57eedc4930"
    sha256 arm64_monterey: "ccba3ea41228197e3c59b93a1fff7c07a386e80a6c556148882cf45bdd0fd4d7"
    sha256 sonoma:         "5b291b7dc052238e8eee4b1b4e5f82b40c84a93c342cabcb94b76a41bed10a74"
    sha256 ventura:        "122648c9eb00130a90f204a1fad3a25ffc9cc2a64044e60bcdcf6c8883474178"
    sha256 monterey:       "d0dfa5ffd7fb269ca5709d2234c524fe9eb59f7d22f413dc943034621e1c27ee"
    sha256 x86_64_linux:   "acca0e04ffd203e54e8aad6d04a56c7c41bb621c60887a08de00c8a92071aa6f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "enchant"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gmime"
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "gtkspell3"
  depends_on "harfbuzz"
  depends_on "pango"

  def install
    # use brew name for gtk3 version of tool update-icon-cache
    inreplace "pan/icons/Makefile.am", "gtk-update-icon-cache", "gtk3-update-icon-cache"

    ENV.append "CXXFLAGS", "-std=c++11"

    system "NOCONFIGURE=1 ./autogen.sh"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-gnutls"
    system "make"
    system "make", "install"
  end

  test do
    # Test fails on headless CI
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    minimal = testpath/"minimal.nzb"
    minimal.write <<~EOS
      <?xml version="1.0" encoding="iso-8859-1"?>
      <!DOCTYPE nzb PUBLIC "-//newzBin//DTD NZB 0.9//EN" "http://www.newzbin.com/DTD/nzb/nzb-0.9.dtd">
      <nzb xmlns="http://www.newzbin.com/DTD/2003/nzb">
        <file poster="NeM &lt;NeM@orion.org&gt;" date="1698128304" subject="test - &quot;wizard.jpg&quot;  yEnc">
          <groups>
            <group>0.test</group>
          </groups>
          <segments>
            <segment bytes="80796" number="1">pan$d1fb3$7054e426$ef264b33$dab0ec15@orion.org</segment>
          </segments>
        </file>
      </nzb>
    EOS

    # this test works only if pan has not yet been configured with news servers
    assert_match "Please configure Pan's news servers before using it as an nzb client.",
      shell_output("#{bin}/pan --nzb #{testpath}/minimal.nzb 2>&1", 1)
  end
end
