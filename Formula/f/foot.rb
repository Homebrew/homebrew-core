class Foot < Formula
  desc "Fast, lightweight and minimalistic Wayland terminal emulator"
  homepage "https://codeberg.org/dnkl/foot"
  url "https://codeberg.org/dnkl/foot/archive/1.21.0.tar.gz"
  sha256 "b93b196a3fbab86678c54be627557bdc7b1fc8042d99b14c4a74b149f60bcd52"
  license "MIT"

  bottle do
    sha256 arm64_linux:  "c06ce1e07f6a87550843708334ad11b6a868a3f433346f7d516732a6bc6319d0"
    sha256 x86_64_linux: "6d95e6265f1ff32c77f90b680c0e00b16b1cdc230a1c09f96b1807485c7cd938"
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
