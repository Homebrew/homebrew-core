class ProbeRsTools < Formula
  desc "Collection of on chip debugging tools to communicate with microchips"
  homepage "https://probe.rs"
  url "https://github.com/probe-rs/probe-rs/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "73cd494f6864d4a74709a9c8adc251105c27d039f91a8b05a01c1ac10a07aab9"
  license "Apache-2.0"
  head "https://github.com/probe-rs/probe-rs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed154405d1f3cc91ac0862ece1042adf2ff9ec2843e4eb1986a43d9eb8cbdda5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92e6587c44bb9b278ec45baaabff1457240a57459224965650116bf77e120b4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "616034c2f4580a2b58122eb91a434593954e183e9ac2e28e0a985d6979884a84"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce830609bc40f7a91855727da68d99950ae387af8d41d1444d9f65b6009111ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e859833bbef36d7d80a7fba1578f07fa4c56cfdc05cc5b197bb6a8d5ee636807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bd9ef243131eebce3701347fb267d5506bcc03e2cbcd8482f9fd2a9e405ff3a"
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
