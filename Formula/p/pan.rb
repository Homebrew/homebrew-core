class Pan < Formula
  desc "Usenet newsreader that's good at both text and binaries"
  homepage "https://gitlab.gnome.org/GNOME/pan"
  url "https://gitlab.gnome.org/GNOME/pan/-/archive/v0.161/pan-v0.161.tar.bz2"
  sha256 "4c2c34b9e4a13275b73fae4f5dbdb3f857cf6b58c4813a373dd9d67ce37779d9"
  license "GPL-2.0-only"

  bottle do
    sha256 arm64_sequoia: "35f4b99a7bdcb408b9f6a7ec4ea839df25204a73e07cbd2bcf54d4df7524569c"
    sha256 arm64_sonoma:  "3f55ddfdcfb08f1b827b2c4edfe64cbed1b9d85fdeb8fd15fe88cf569819195b"
    sha256 arm64_ventura: "4e9d21bdc040a523f50becffca34332b18b54277f6cdb534628bc5e2c33d7083"
    sha256 sonoma:        "923377d62ba469d533c4eaa7e7f9ec74c1726e839b451bbc12c59d0cb4789a1d"
    sha256 ventura:       "f9034fe247a568d255d7fe8b477678224971504679006733a61212440df3965e"
    sha256 x86_64_linux:  "01192961eb2ea62a502ab3da7c28751a97cee269691f3bb12493ad1b58868c16"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build

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
