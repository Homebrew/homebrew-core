class Pan < Formula
  desc "Usenet newsreader that's good at both text and binaries"
  homepage "https://gitlab.gnome.org/GNOME/pan"
  url "https://gitlab.gnome.org/GNOME/pan/-/archive/v0.164/pan-v0.164.tar.bz2"
  sha256 "862609baaabbc516fe23fd9f62ae54f1a6b6481178913f3c5a6f4597d0c39244"
  license "GPL-2.0-only"

  bottle do
    sha256 arm64_tahoe:   "a0797478edc5d73b92d1b72296c57530dec5be4263d7ad1944bafbdd789f06f6"
    sha256 arm64_sequoia: "deb86a97c8007b261347fea9f0db7b925f5b8081629097a5f5480a668ffba530"
    sha256 arm64_sonoma:  "21d6e8b62f18043750c6f509c7bd3868d8832b3e568a252c15a604759ae4fe40"
    sha256 arm64_ventura: "9d051c43ee5c8a43212f69b9c3fb9c1235d822c5522bb31fa710899325f5bec0"
    sha256 sonoma:        "14f55fb5865ea9b048326801a5826e5ca3509ac733d239f136a3f16f555acc3a"
    sha256 ventura:       "6a0c7b8e2bfea9de1de7f94be6b132ea4505c4c46d4d9429487d99c0690e8930"
    sha256 arm64_linux:   "31b3fc10fe506b19e6d70602566a5a4991b51b5167c593fc5a2586341fe76ff9"
    sha256 x86_64_linux:  "f66553706f7464e5296b8251b55bace50e3cf3d6a5527b42405b9d8f9dba5983"
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
