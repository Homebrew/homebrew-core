class Elf2uf2Rs < Formula
  desc "Convert ELF files to UF2 for USB Flashing Bootloaders"
  homepage "https://github.com/JoNil/elf2uf2-rs"
  url "https://github.com/JoNil/elf2uf2-rs/archive/refs/tags/2.1.1.tar.gz"
  sha256 "c6845f696112193bbe6517ab0c9b9fc85dff1083911557212412e07c506ccd7c"
  license "0BSD"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2502c3b12665d304fc3f016c68eef40119b4b529867d67cc26fb641e844b5de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cd37371cbeb7dd6be732e6db993b226dea3dc7fbbd2c321e81665c68c6de036"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e0726aed0c347586d3a4eef4b49ce9ef93d2560f31ae686f48381babae5f508"
    sha256 cellar: :any_skip_relocation, sonoma:        "592612fe9e209df4f432354b7cc471f83a41ab679a13ce2ab904dd1431ffd9ab"
    sha256 cellar: :any_skip_relocation, ventura:       "5942db8bcb33f094ba359873643e78f39ec73e12e2b85fdc076a4abbb63ab08d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bee91ffd1bed1d4f42d0eb45e4c21539b1f8089710b08d007d00a1090bfb352d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85a5d2a22806dbd123281e4ab4d9f078ae31a81c29f0ad10ee199e4fc7375e5b"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args
    (pkgshare/"examples").install Dir.glob("*.elf")
    (pkgshare/"examples").install Dir.glob("*.uf2")
  end

  test do
    system bin/"elf2uf2-rs", pkgshare/"examples"/"hello_usb.elf", "converted.uf2"
    assert compare_file pkgshare/"examples"/"hello_usb.uf2", testpath/"converted.uf2"
  end
end
