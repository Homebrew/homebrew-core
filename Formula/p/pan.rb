class Pan < Formula
  desc "Usenet newsreader that's good at both text and binaries"
  homepage "https://gitlab.gnome.org/GNOME/pan"
  url "https://gitlab.gnome.org/GNOME/pan/-/archive/v0.163/pan-v0.163.tar.bz2"
  sha256 "f15b5ad48729424fc5c31d1c3b609563374f1993e4b37ed17cf36f5e4e65589c"
  license "GPL-2.0-only"

  bottle do
    sha256 arm64_sequoia: "fe6f4ce88b08fc33e3bbc24966ebaccd7a097d0c0f7f7e74f0393b87c0ddd246"
    sha256 arm64_sonoma:  "8f8c65db6328a70fde77845c576a3e4d7a56ce81f51d49f3826cb3b12e6aab3c"
    sha256 arm64_ventura: "92f3339ce3499cd6f4991ea03a011553c4c3304e86cddbedc159b928d6aee08e"
    sha256 sonoma:        "57237340a6f1a9e19357ca236115a08d4a6a9cf91d2557259d883bb07c449de3"
    sha256 ventura:       "9349b86b4e76eb15423480985c961d222c70627858ed19cc3bf1e5d2a85a75cb"
    sha256 arm64_linux:   "eb919df1a737833206151621a14bc24f8666695d46ef5e11cbdae64806076ebb"
    sha256 x86_64_linux:  "b57e6f564d8e793ea6372443e5be72251d1619e9fa3af7c231ac8b1378312b7b"
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
