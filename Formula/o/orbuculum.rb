class Orbuculum < Formula
  desc "Arm Cortex-M SWO/SWV Demux and Postprocess"
  homepage "https://github.com/orbcode/orbuculum"
  url "https://github.com/orbcode/orbuculum/archive/refs/tags/V2.2.0.tar.gz"
  sha256 "6614fba7044aa62e486b29ff4a81d0408d6e88499249bf2b839ccadfc54eec83"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3b232ad18dc8d43548fc1bfa68e3efef76ee05c5a17d9a4d3ec178139ce65dac"
    sha256 cellar: :any, arm64_sequoia: "637ba000bafcaf9a19397b9039d64ec637079054b768f9494e54b27e36de95cc"
    sha256 cellar: :any, arm64_sonoma:  "4ec20a9f9f3682853155e53ed4abaeff98c952f59e83ff648b0c5a8fd3c52e7a"
    sha256 cellar: :any, arm64_ventura: "c66bb8358fc5fd4e83f23da5748cfad5b57446783c4adce427e1c1d2c51b864e"
    sha256 cellar: :any, sonoma:        "188b4f0e858841b75414119a8c799da7c5fba2c3f83d584c4b94c1d6e0286d13"
    sha256 cellar: :any, ventura:       "cb18bac79798cffe77da5e4d05a14fcb1bc4f09fdda488d3f24eb482e740b33d"
    sha256               arm64_linux:   "f08fbd65255af3b5ab905a393e2dbd29407f39caabd94c07ca2d07df556af439"
    sha256               x86_64_linux:  "83fd1219323905730efd83508f2c67500ce83392b478b7b2a1f376a98addf3d5"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "capstone"
  depends_on "dwarfutils"
  depends_on "libusb"
  depends_on "sdl2"
  depends_on "zeromq"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "libelf" => :build
  end

  on_linux do
    depends_on "elfutils"
  end

  def install
    # Unbundle `dwarfutils`
    inreplace "meson.build", "= subproject('libdwarf').get_variable('libdwarf')", "= dependency('libdwarf')"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "orbuculum version #{version}", shell_output("#{bin}/orbuculum --version 2>&1", 255)
    assert_match "orbcat version #{version}", shell_output("#{bin}/orbcat --version 2>&1", 255)
    assert_match "orbdump version #{version}", shell_output("#{bin}/orbdump --version 2>&1", 255)
    assert_match "orbfifo version #{version}", shell_output("#{bin}/orbfifo --version 2>&1", 255)
    assert_match "orblcd version #{version}", shell_output("#{bin}/orblcd --version 2>&1", 255)
    assert_match "Elf File not specified", shell_output("#{bin}/orbmortem 2>&1")
    assert_match "This utility is in development. Use at your own risk!!\nElf File not specified",
                 shell_output("#{bin}/orbprofile 2>&1", 254).delete("\r")
    assert_match "Elf File not specified", shell_output("#{bin}/orbstat 2>&1", 254)
    assert_match "Elf File not specified", shell_output("#{bin}/orbtop 2>&1", 247)
    assert_match "No devices found", shell_output("#{bin}/orbtrace 2>&1")
    assert_match "orbcat version #{version}", shell_output("#{bin}/orbzmq --version 2>&1", 255)
  end
end
