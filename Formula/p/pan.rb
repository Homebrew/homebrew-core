class Pan < Formula
  desc "Usenet newsreader that's good at both text and binaries"
  homepage "https://gitlab.gnome.org/GNOME/pan"
  url "https://gitlab.gnome.org/GNOME/pan/-/archive/v0.160/pan-v0.160.tar.bz2"
  sha256 "6506955fc3c94a7e395f82763f45a63dcb564028419ea32249090997c08962a9"
  license "GPL-2.0-only"

  bottle do
    sha256 arm64_sequoia:  "3d99d6d19ec9376983bf307625e57a86bd42112ac88a02b4fe662e86ace693ff"
    sha256 arm64_sonoma:   "ed0101aa7ef6a55f7c44f5dd93d321e5f91731819017843c2e0972d231c375d3"
    sha256 arm64_ventura:  "150c7878f91aa47b9bb5d207dd35ef1fb6b3a118365a9ccfd06fd98b0a4f3629"
    sha256 arm64_monterey: "aab4b5bfc736daa16ea5fe040b8df21fef8b7e714c8934002921a1eba6410c4f"
    sha256 sonoma:         "e0073c66807b3e8232900fec88462999893bf4e32c3536bb70b2f0fadc856f6c"
    sha256 ventura:        "66cd09584cc4d9db3d300f7ddcf015c8ca2d49d12795b9f73a8580db981b10c9"
    sha256 monterey:       "e19ee512b8432bd1865a3ac97df9b7468a345e736df5dc5fe5a9f94fe29756d3"
    sha256 x86_64_linux:   "fa9be5e5e4c9047dbaf84acf4920464e2c04767de4826943f39d76719b8e92fb"
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
