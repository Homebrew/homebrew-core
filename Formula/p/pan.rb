class Pan < Formula
  desc "Usenet newsreader that's good at both text and binaries"
  homepage "https://gitlab.gnome.org/GNOME/pan"
  url "https://gitlab.gnome.org/GNOME/pan/-/archive/v0.165/pan-v0.165.tar.bz2"
  sha256 "0e393f81efe59ec9169cf8b0d519500e4da7c73f8cb3635d2c5c0f98db3bf573"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "fc39105d5b48f22b138d5e626c42098275959204729ef193ef91ae6837d504d7"
    sha256 arm64_sequoia: "2e171ead5e91ddde91ec9adfbc04f0a87587e23b98ad31bac4499669f941b823"
    sha256 arm64_sonoma:  "df046b01f313cdf657b78d17b4166c882844e72181c685c12072dbc6bc18a4bb"
    sha256 sonoma:        "cdce7a683c5aaf45652ac0bbe8e440fdea8ca44169bb24e1379865023160d5b6"
    sha256 arm64_linux:   "69cb546174ad3bd1c3d534cb3a1ee5aa40f42b747fef0e23d5121be2efc450db"
    sha256 x86_64_linux:  "9f4fa7cdfb0692cc38119803c6c2d97de0b1e64dfef6f4244a0cc25e7322bf01"
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

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
  end

  on_linux do
    depends_on "xorg-server" => :test
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
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
    cmd = "#{bin}/pan --nzb #{testpath}/minimal.nzb 2>&1"
    cmd = "#{Formula["xorg-server"].bin}/xvfb-run #{cmd}" if OS.linux? && ENV.exclude?("DISPLAY")
    assert_match "Please configure Pan's news servers before using it as an nzb client.", shell_output(cmd, 1)
  end
end
