class ProbeRsTools < Formula
  desc "Collection of on chip debugging tools to communicate with microchips"
  homepage "https://probe.rs"
  url "https://github.com/probe-rs/probe-rs/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "d0c7e8fe4d8b5795ba9cd3e7f09f91ae1373a3226f106ab09776ec6dc646b8ab"
  license "Apache-2.0"
  head "https://github.com/probe-rs/probe-rs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fde0f0bed4c13c857911063d98b6b9c8212d0fe280fc9753530da3b6451c38f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "454052b0ea56ce7ecfd8b6d6af56b976712e101ac36d479b6ae4c74cb99acaed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e97cd23aa96e6f55f40d2d263c224ce18e7459fe9088e60849b227e8203cd67"
    sha256 cellar: :any_skip_relocation, sonoma:        "1be8558aee7092643c05fd1e49a00b627ebb0769274e41fec1d98f970349e8ae"
    sha256 cellar: :any_skip_relocation, ventura:       "1c55118312a569246707664ad50ef3b9e458aef9c5f274efe0e9dbe44c82cff9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67b571691b4c83c721e4052f1c492ea1c5a3459556cd407ab4ffeb01184ca6e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fce905ac6d073af446579dd6ed094806b282ca56c6081222f20e949468867c7"
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
