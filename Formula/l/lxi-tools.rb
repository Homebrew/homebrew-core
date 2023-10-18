class LxiTools < Formula
  desc "Open source tools for managing network attached LXI compatible instruments"
  homepage "https://github.com/lxi-tools/lxi-tools"
  url "https://github.com/lxi-tools/lxi-tools/archive/refs/tags/v2.7.tar.gz"
  sha256 "6196980e82be2d143aa7f52e8e4612866b570cfce225d7d61698d2eeb1bf8a00"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "75be3338f9fca193241c6abee6c540f5e1139deab210b0f9b383c9d8984c2186"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ca1f9223772ee912d686f6652c7b699324850fb4dccc03d5a77be23c66afcf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6090dd52015d0d7d17a705742793a8986b9339d5e2c9aed7595f0a9b142b992"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1531d09c7f93a01b13b413a708f076c05c08c828c6e42092cd8e670c8aca36c"
    sha256 cellar: :any,                 sonoma:         "706944ebfca46a511b43ba0336cc1727ca21d61c90b06954d8c41655d2cd62a9"
    sha256 cellar: :any_skip_relocation, ventura:        "69b704762e5a07d767978da9109a8980bcf86374c4d537b5eb034f7dbdd31413"
    sha256 cellar: :any_skip_relocation, monterey:       "acd842a43b3b4c9e2476728f8e40884b701d31c6a85452559cb61a89adfbc0ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9bcbc6c149c2ca24dbcb1cae8f07b0ccba087cd1d6fe4c2ebe1b479b17fe842"
    sha256                               x86_64_linux:   "4dd930cc0b1e29dbdbe11595e0112fd420729776cf0dedcdb76bc73d092a1df6"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "desktop-file-utils"
  depends_on "gtksourceview5"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libadwaita"
  depends_on "liblxi"
  depends_on "lua"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    rm_f "#{share}/glib-2.0/schemas/gschemas.compiled"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match "Error: Missing address", shell_output("#{bin}/lxi screenshot 2>&1", 1)
  end
end
