class Orbuculum < Formula
  desc "Arm Cortex-M SWO/SWV Demux and Postprocess"
  homepage "https://github.com/orbcode/orbuculum"
  url "https://github.com/orbcode/orbuculum/archive/refs/tags/V2.1.0.tar.gz"
  sha256 "ccdd86130094001a0ab61e5501a6636e12c82b0b44690795a2911c65c5618c46"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sonoma:   "460ce4bce5f532fe8534d480b717419b56bba21b7a00a3702322e2fd1f3722cc"
    sha256 cellar: :any, arm64_ventura:  "58a8a18573c584ab9c2f1cf66acf6008dd0925b4e574fbdd2fc059594033fedd"
    sha256 cellar: :any, arm64_monterey: "13099ad1fce7ca98c85ef6d35707e7a9963a5c6dc81ed27434acb5db65b78d7a"
    sha256 cellar: :any, sonoma:         "739074b3d4ca04c290debcecbdeaa4d0675295dbe7703227aed06f72d300cb08"
    sha256 cellar: :any, ventura:        "162cf2d49bbb1b1019862162cfebc5a6e68b5ceba05c20b58214de8ca714f089"
    sha256 cellar: :any, monterey:       "075d0e0c2aa5bb76b6dbbef10bfc32061bd54b5fd0f48f9f29d4053f520f6b6c"
    sha256               x86_64_linux:   "08a9dcd2af4ebccb6db29fd6c8cd83e7546151e35062af3ecaaddd91bd9e8cc4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "capstone"
  depends_on "libusb"
  depends_on "sdl2"
  depends_on "zeromq"

  uses_from_macos "ncurses"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build", "--tags", "devel,runtime"
  end

  # The tools do not report their version correctly when installed from a
  # GitHub release rather than from Git directly for versions <= 2.1.0.
  # This has now been rectified, and the versions can be tested for future
  # releases.
  test do
    assert_match "orbuculum version undefined", shell_output("#{bin}/orbuculum --version 2>&1", 255)
    assert_match "orbcat version undefined", shell_output("#{bin}/orbcat --version 2>&1", 255)
    assert_match "orbdump version undefined", shell_output("#{bin}/orbdump --version 2>&1", 255)
    assert_match "orbfifo version undefined", shell_output("#{bin}/orbfifo --version 2>&1", 255)
    assert_match "orblcd version undefined", shell_output("#{bin}/orblcd --version 2>&1", 255)
    assert_match "Elf File not specified", shell_output("#{bin}/orbmortem 2>&1")
    assert_match "This utility is in development. Use at your own risk!!\nElf File not specified",
                 shell_output("#{bin}/orbprofile 2>&1", 254).sub("\r", "")
    assert_match "Elf File not specified", shell_output("#{bin}/orbstat 2>&1", 254)
    assert_match "Elf File not specified", shell_output("#{bin}/orbtop 2>&1", 247)
    assert_match "No devices found", shell_output("#{bin}/orbtrace 2>&1")
    assert_match "orbcat version undefined", shell_output("#{bin}/orbzmq --version 2>&1", 255)
  end
end
