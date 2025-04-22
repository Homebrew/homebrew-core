class Pan < Formula
  desc "Usenet newsreader that's good at both text and binaries"
  homepage "https://gitlab.gnome.org/GNOME/pan"
  url "https://gitlab.gnome.org/GNOME/pan/-/archive/v0.162/pan-v0.162.tar.bz2"
  sha256 "f33b136621f7c0e7feac9ed6d0ff3fe15013335a100cb48b4151f4528be10059"
  license "GPL-2.0-only"

  bottle do
    sha256 arm64_sequoia: "5b8acb1334a483317caf49231f22b3e7c88a774fc6d7ae20fe8f121d6ab63219"
    sha256 arm64_sonoma:  "445b8bcc58239fc28ac1ca22356bf46be9af2f63f4ba9cfe7cb46f389b37b05c"
    sha256 arm64_ventura: "874072ee564ccd310d01af2f7975fa9d4bd3de07070f201e82e4c6c75b365b48"
    sha256 sonoma:        "8bf0fdba14f34573e28ea4c186071827dd7e48e682eb1414ccf13ab0fc0cb21f"
    sha256 ventura:       "9e262aca5d840b964d81ea871a56bf80096e7af7c25feef09e5cbd644ec35878"
    sha256 arm64_linux:   "9ac64caa1826df8797d08c20e3a7c88fe7b8fadc70872c2c610501aab0a9d040"
    sha256 x86_64_linux:  "7b6334b42d03f519f8bbbc6e97c4ce20de77a18fde5ae5dc1df3d0cadcfc1019"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "enchant"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gmime"
  depends_on "gnutls"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "gtkspell3"
  depends_on "harfbuzz"
  depends_on "pango"

  uses_from_macos "zlib"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
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
    minimal.write <<~XML
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
    XML

    # this test works only if pan has not yet been configured with news servers
    assert_match "Please configure Pan's news servers before using it as an nzb client.",
      shell_output("#{bin}/pan --nzb #{testpath}/minimal.nzb 2>&1", 1)
  end
end
