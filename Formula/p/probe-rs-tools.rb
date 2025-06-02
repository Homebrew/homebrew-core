class ProbeRsTools < Formula
  desc "Collection of on chip debugging tools to communicate with microchips"
  homepage "https://probe.rs"
  url "https://github.com/probe-rs/probe-rs/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "bf90e22c2bf9a843f47e71e0701b3d95975cf6c1eaa525981d25b07e40276f24"
  license "Apache-2.0"
  head "https://github.com/probe-rs/probe-rs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9acc3f6e7fe7ff3989385dc78281474fce0cd3133ff2253205a3ef46fa34b60a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5caa4f823e60a9214ad1f07ad1da313a33deb4bfa345ba8a3d5b2391fa69ad6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0496d931400d84b418f786a074a351c827ae4a07d3ba517758b61c3d51594463"
    sha256 cellar: :any_skip_relocation, sonoma:        "0791a7fbe77d43bc7963b75f2d9a7da24b1cf070f950bb73d6cb63a3fc5b3760"
    sha256 cellar: :any_skip_relocation, ventura:       "a2cef2bca4a5b56cc782152cc42020e6a95ae9f6f5a740d30b4be9990bd4f2fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89b956de17bc87f74c2f21947852d6fabfae7a5c06a5267061f45eedc8a4cdfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85650b16bc9d268e3b54f633447f0508700a81e605bcd32b2a60279bb4aee199"
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
