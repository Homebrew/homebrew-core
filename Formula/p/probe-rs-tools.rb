class ProbeRsTools < Formula
  desc "Collection of on chip debugging tools to communicate with microchips"
  homepage "https://probe.rs"
  url "https://github.com/probe-rs/probe-rs/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "8a7477a4b04b923ef2f46a91d5491d94e50a57259efef78d4c0800a4a46e4aee"
  license "Apache-2.0"
  head "https://github.com/probe-rs/probe-rs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d84e0446b2ce2ff46054933885c58fecc607907233de2a8914e01ad91676a9d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "099d23a256deba345a765ef686d69f2a7c82f3ea6f733c3e00d788922dde1aaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af610c338d9565acc2ab9f0784593574b336f90e7da589ab8d0c64f1d7c1a3e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ad63c7bf0a25744817ea1ab7275348736ef0add2725099192323845d3a798dc"
    sha256 cellar: :any_skip_relocation, ventura:       "fb5c33cc19d727874515db05d72210f06f3f539dc6c13c9b1ceae7a716c426bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0e4be3bbda804d9e0260fcc235cf8aa43fecc59f8f733332630f926360a8cd4"
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
    output = shell_output("#{bin}/probe-rs chip list")
    assert_match "nRF52833_xxAA", output # micro:bit v2
    assert_match "STM32F303VCTx", output # STM32F3DISCOVERY
  end
end
