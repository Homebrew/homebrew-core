class Elf2uf2Rs < Formula
  desc "Convert ELF files to UF2 for USB Flashing Bootloaders"
  homepage "https://github.com/JoNil/elf2uf2-rs"
  url "https://github.com/JoNil/elf2uf2-rs/archive/refs/tags/2.1.1.tar.gz"
  sha256 "c6845f696112193bbe6517ab0c9b9fc85dff1083911557212412e07c506ccd7c"
  license "0BSD"

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
