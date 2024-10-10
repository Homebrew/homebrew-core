class Orbuculum < Formula
  desc "Arm Cortex-M SWO/SWV Demux and Postprocess"
  homepage "https://github.com/orbcode/orbuculum"
  url "https://github.com/orbcode/orbuculum/archive/refs/tags/V2.2.0.tar.gz"
  sha256 "6614fba7044aa62e486b29ff4a81d0408d6e88499249bf2b839ccadfc54eec83"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "b2ef0c97ab87adebbc5058690f21ff1a65da6050846e583c32391acc180c9636"
    sha256 cellar: :any, arm64_sonoma:  "d34869941adc81fe89faf96938bff1d942e3712789b2653de9ce6e1c6bab9842"
    sha256 cellar: :any, arm64_ventura: "f760943e7594b9e1489341e0960375c0acabb46ca2758d303dc6b6e07cb09e67"
    sha256 cellar: :any, sonoma:        "30dbcf1b1a0c3b492c3f4058fd1b63177b3223d81c76306334ad87420041a81e"
    sha256 cellar: :any, ventura:       "ee99b891380579be06c4419f1952676469845ba51b3a3832d99f0f949ccd9097"
    sha256               x86_64_linux:  "e426f5df95dd41d4fcc31f85851f4a4b5a91f5211c3b756dfb900829ab437d9c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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
                 shell_output("#{bin}/orbprofile 2>&1", 254).sub("\r", "")
    assert_match "Elf File not specified", shell_output("#{bin}/orbstat 2>&1", 254)
    assert_match "Elf File not specified", shell_output("#{bin}/orbtop 2>&1", 247)
    assert_match "No devices found", shell_output("#{bin}/orbtrace 2>&1")
    assert_match "orbcat version #{version}", shell_output("#{bin}/orbzmq --version 2>&1", 255)
  end
end
