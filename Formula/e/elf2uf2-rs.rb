class Elf2uf2Rs < Formula
  desc "Convert ELF files to UF2 for USB Flashing Bootloaders"
  homepage "https://github.com/JoNil/elf2uf2-rs"
  url "https://github.com/JoNil/elf2uf2-rs/archive/refs/tags/2.2.0.tar.gz"
  sha256 "7fd821623343bf6af63543a008caf49c1b7ad9f7e6df24403ae9c7a6bf325b54"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b6d36f51c622f0baf332930c8ae232cdf04395cfdae78fae45b8560ec51ab54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b7ddb264f138b166b3f291dd3f98cb3beba2bff0a7823d36f45c2f4e98b80d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0a747e75dfe8250d1722d3781f57bdde73d5b7855150e3d4b344d94099d14a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b88fb516410369897f97f16030f48eb276955bb32c9dbf446d532eca2add68a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e95dda0368015306a494e58f3bbd22717e23b592391b8b0dd0fcd30a0cd617c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f360ea5ae0f17d0a57012f80aa69c18a887d964211475e33414e32442d17616"
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
    system bin/"elf2uf2-rs", pkgshare/"examples/hello_usb.elf", "converted.uf2"
    assert compare_file pkgshare/"examples/hello_usb.uf2", testpath/"converted.uf2"
  end
end
