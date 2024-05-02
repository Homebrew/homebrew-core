class Pan < Formula
  desc "Usenet newsreader that's good at both text and binaries"
  homepage "https://gitlab.gnome.org/GNOME/pan"
  url "https://gitlab.gnome.org/GNOME/pan/-/archive/v0.158/pan-v0.158.tar.bz2"
  sha256 "fb3673ef34fb3fb1008af7ed22fe6c82cfb603b16df9d1edba4259595cb9d303"
  license "GPL-2.0-only"

  bottle do
    sha256 arm64_sonoma:   "89f06d595c6eb77742628c0033548344218de3c2656ffa39ad1198ab2202897f"
    sha256 arm64_ventura:  "1dd8b88602d5a43b10a3efe90d14aa7222908834c2867b9c1db21b676248e251"
    sha256 arm64_monterey: "6a2697c9055f1507948b595c02c9bb89e001c5e0123d29c9c95a53ca77f80e04"
    sha256 sonoma:         "66270b958f281c5f4b13cb96d228fc0415a3acbd96c38de3bc917ed443b67b2d"
    sha256 ventura:        "83311358c94d27d3e1e4e8ca77c293a459b11678f7b5f2559a19609f57e39173"
    sha256 monterey:       "1c39a380c4bb4333cffea6a48a27e66e7ce33f236a1cf3fd7deb7ab70bfea6d0"
    sha256 x86_64_linux:   "186ae8e0a3d60c00cc0bf8aa35f8dda9247bd0644d7a6e887a8e0da721288063"
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

  # Specify C++11 standard to fix the build on macOS
  # upstream build patch, https://gitlab.gnome.org/GNOME/pan/-/merge_requests/51
  patch do
    url "https://gitlab.gnome.org/GNOME/pan/-/commit/bd9e8fbcbda40c8c8c4cc6d77f2776382c82ae15.diff"
    sha256 "ab31b1cc25638b0eab18ec0f387c38f30d197570aa6741559d25e8044fa7cedf"
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
