class Pan < Formula
  desc "Usenet newsreader that's good at both text and binaries"
  homepage "https://gitlab.gnome.org/GNOME/pan"
  url "https://gitlab.gnome.org/GNOME/pan/-/archive/v0.159/pan-v0.159.tar.bz2"
  sha256 "96f05c4ff60a009969bec79b6ba76b01528186d9c86fce55d158f2b4dc0876e2"
  license "GPL-2.0-only"

  bottle do
    sha256 arm64_sonoma:   "54d0b93e0ce8513bde012288e8545fddda341667dc3ff79b67e96342d3959ecf"
    sha256 arm64_ventura:  "c4ddc501ebde818151ce5724c2d799049f59f1165b2afc8ec01c9f5216d028ac"
    sha256 arm64_monterey: "440da042ec88422d11264f02ee6dce1f530e8644e602f70f3abf719b8df33610"
    sha256 sonoma:         "487918c021182d240cf4153a2f7e8680303a4e21ab38deb3b003524565d61497"
    sha256 ventura:        "6d9cb747b69a89f1cc3d893a1ec88697646e8c2c27275f0dc1f049ca247a2150"
    sha256 monterey:       "328c72198d69c3b8f5af8c14c366f81d86c9aa61074efa0e29601cd78f6864a9"
    sha256 x86_64_linux:   "12943f01d60be32ca5f87e8877994a6a46ca6ab3af96d3c3fefdbfec7bde6eeb"
  end

  depends_on "cmake" => :build
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

  uses_from_macos "zlib"

  on_macos do
    depends_on "at-spi2-core"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
