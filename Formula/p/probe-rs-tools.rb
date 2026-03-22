class ProbeRsTools < Formula
  desc "Collection of on chip debugging tools to communicate with microchips"
  homepage "https://probe.rs"
  url "https://github.com/probe-rs/probe-rs/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "7a5022d6956daaa8dba96bb3aedf2ace0b5a76a60729d93971c9dab439ac045e"
  license "Apache-2.0"
  head "https://github.com/probe-rs/probe-rs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72561b7cfe019ec5388177cebfc6a282c072db438126f50fd6ba1040173fe7c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c469c1f12f639a99a87cbe82a9e61fb72e35ccf77223cb146e0178de61069817"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4883d91b31024bcc7ba8325e2bbd6942848b3e344090e6f3b1ba0e5ab6b8db92"
    sha256 cellar: :any_skip_relocation, sonoma:        "22c29bc2cfc86bc983ba5380adfe2000cee668230fd6454b46cdc13fa72f9062"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f2f7b1c27291038dd79450360855ed5c5e503607469666f76f91324265fea75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "443675403cf06b8a7494b922aebd0dd1fbb491958e387b83d732fc486e02e8f7"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "probe-rs-tools")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/probe-rs --version")

    output = shell_output("#{bin}/probe-rs chip list")
    assert_match "nRF52833_xxAA", output # micro:bit v2
    assert_match "STM32F3 Series", output
  end
end
