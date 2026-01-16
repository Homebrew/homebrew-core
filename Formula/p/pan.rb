class Pan < Formula
  desc "Usenet newsreader that's good at both text and binaries"
  homepage "https://gitlab.gnome.org/GNOME/pan"
  url "https://gitlab.gnome.org/GNOME/pan/-/archive/v0.165/pan-v0.165.tar.bz2"
  sha256 "0e393f81efe59ec9169cf8b0d519500e4da7c73f8cb3635d2c5c0f98db3bf573"
  license "GPL-2.0-only"

  bottle do
    sha256 arm64_tahoe:   "b8d538f62f76e016d4f151ee754488cc49b99330e24d4fc8b35a18237890ea99"
    sha256 arm64_sequoia: "03fe7b99d3137b9e116e95e5a5e7c9d3820014d055cc3ed614f8149920fcd30b"
    sha256 arm64_sonoma:  "aa1c2cf6c95e9851e19147dae6c0ff6e79b157297e1fd13db79b21fa61319cb8"
    sha256 sonoma:        "b337ee2e0dee5d89fb6928f12c033fab23c434d72f58b4cd613cfcf80b87f298"
    sha256 arm64_linux:   "a44bd5ffc0d6dcbdd4ea1fc868cbc1b98a1a9690d15224e2405fd6ae4fc1d24d"
    sha256 x86_64_linux:  "fce6566f60df60476732cf33270fb43c9ea7e7ecb8d871efb4573fae0003fdff"
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

  on_linux do
    depends_on "xorg-server" => :test
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
