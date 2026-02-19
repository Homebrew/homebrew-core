class Foot < Formula
  desc "Fast, lightweight and minimalistic Wayland terminal emulator"
  homepage "https://codeberg.org/dnkl/foot"
  url "https://codeberg.org/dnkl/foot/archive/1.25.0.tar.gz"
  sha256 "442a42d576ec72dd50f2d3faea8a664230a47bac79dc1eb6e7c9125ee76c130f"
  license "MIT"

  bottle do
    sha256 arm64_linux:  "f1192f28c18f8011b3cc1334ab49180513b6b7d3d096cd2d020777431abb501c"
    sha256 x86_64_linux: "103841af714686d022f65eaea25599c220f4e75d1196160843fa397cb38ccf30"
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
