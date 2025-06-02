class Foot < Formula
  desc "Fast, lightweight and minimalistic Wayland terminal emulator"
  homepage "https://codeberg.org/dnkl/foot"
  url "https://codeberg.org/dnkl/foot/archive/1.22.3.tar.gz"
  sha256 "1c9f09c119c5b24bd1934ce515e70f402b7d1b2c55f8218a16eddaa26e3f6fb0"
  license "MIT"

  bottle do
    sha256 arm64_linux:  "a345e2e90ac6a7997bed073afc4269b941b9c6aa5bae6b81b585649614cc82d1"
    sha256 x86_64_linux: "10fd5473034fbd167df7b0e9bc8b75a240e529b07c8a9a0861f9abd7f4862b94"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "scdoc" => :build
  depends_on "tllist" => :build
  depends_on "wayland-protocols" => :build

  depends_on "fcft"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libxkbcommon"
  depends_on :linux
  depends_on "pixman"
  depends_on "utf8proc"
  depends_on "wayland"

  def install
    system "meson", "setup", "build", "-Dterminfo-base-name=foot-extra", "-Ddocs=enabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    config_dir = testpath/".config/foot"
    config_file = config_dir/"foot.ini"

    mkdir_p config_dir

    config_file.write <<~INI
      [cursor]
      style=blok
    INI

    assert_match(
      /blok: not one of 'block', 'underline', 'beam'/,
      shell_output("#{bin}/foot --check-config 2>&1", 230),
    )

    rm(config_file)
    config_file.write <<~INI
      [cursor]
      style=block
    INI

    assert_empty shell_output("#{bin}/foot --check-config")
  end
end
