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
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "ebd5fc98ad26b52efc86a68e8bd5da5f8891c1212dca4382bd1dc55c61697e0f"
    sha256 cellar: :any, arm64_sonoma:  "ea72ca06cea3b25c72ced4adbe45457176ff5ce9a2a3850c9ce15f77c9d56315"
    sha256 cellar: :any, arm64_ventura: "1844273329b7624bef902a7578db500bade46d0d4e6f055bd85c47cbb49a829e"
    sha256 cellar: :any, sonoma:        "6fb59089dc3bccd5478c38f162eb76908f50ab352b0980a0ae8e621b305b882c"
    sha256 cellar: :any, ventura:       "c464ab9e54fd94ad671079698b68813746c50af3bfe97e1a9aa7169abb35e27e"
    sha256               arm64_linux:   "4e0735b40e690002488e00b62e92b142bbc36f729ba686e6405f6b8b53537f59"
    sha256               x86_64_linux:  "7c9eb6c5596b7d5a8673f89b7359c325aaeda5937b209d500d5db29392efb06a"
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
                 shell_output("#{bin}/orbprofile 2>&1", 254).sub("\r", "")
    assert_match "Elf File not specified", shell_output("#{bin}/orbstat 2>&1", 254)
    assert_match "Elf File not specified", shell_output("#{bin}/orbtop 2>&1", 247)
    assert_match "No devices found", shell_output("#{bin}/orbtrace 2>&1")
    assert_match "orbcat version #{version}", shell_output("#{bin}/orbzmq --version 2>&1", 255)
  end
end
