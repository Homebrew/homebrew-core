class ProbeRsTools < Formula
  desc "Collection of on chip debugging tools to communicate with microchips"
  homepage "https://probe.rs"
  url "https://github.com/probe-rs/probe-rs/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "289f9d882ea43f90a044429b555e8f416af7075927831d0f444a087cc44846d3"
  license "Apache-2.0"
  head "https://github.com/probe-rs/probe-rs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "421b8aaffb2d8b87beede4d4bec92fab5dadf8604ad832b664428151758b9d14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44db77729bf8969c09b0c8080ef503cc862499703f43ecc0f7a7621d5e9c885c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63a8b780260b1182d9770ded138de754dd7d748333f375d107c0250dfddb5ba6"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb2a01d21ecb72f717b6ed61933846966794ab8f9e0da49c3ffd0ade9058af58"
    sha256 cellar: :any_skip_relocation, ventura:       "c278a17df7eff41c08121fbc5548ebcaf78d3530ff1c4358fd026a6972d7dd30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "522c0ea72a7cd96f86678ff8d25fcec12068b3ad8651612b59d59f40f4b27b35"
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
