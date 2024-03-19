class Pan < Formula
  desc "Usenet newsreader that's good at both text and binaries"
  homepage "https://pan.rebelbase.com"
  url "https://gitlab.gnome.org/GNOME/pan/-/archive/v0.155/pan-v0.155.tar.bz2"
  sha256 "3624ac3171fa8089825ce55b62b053db4f86d592f717c4d874c48ce0e885dff2"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "c08c401b97e32d8934db82f16c2b0e074227dd24925a4f39d6a51998e80be842"
    sha256 arm64_ventura:  "1e14649519c4a583699826739cb764a2aa2fb01f9ae4d7ecd8986785aebecb0a"
    sha256 arm64_monterey: "041774d3ef7be7739b5eff98d9e983e2fc9f18d432166957617d45f105ebd046"
    sha256 sonoma:         "1efce928f716ef06e07190d7131fb35fed49fd9a6127daff0e5d1799d4c96ff6"
    sha256 ventura:        "f4c9efe084a27257401588d8f7349de86098c8e9c8ccf08ee943d80180c09673"
    sha256 monterey:       "7b9d202162e62d67ecaef4fe1b1b6d1416e883c999ce21cc16ed649f45003736"
    sha256 x86_64_linux:   "9b26beb9076367133889cbe9b8204c503e10c087bc9f15159fbd074a5f062392"
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
