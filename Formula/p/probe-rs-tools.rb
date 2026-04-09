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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8504d65b58632718d04633f2fa4e7a8071911a51c1a3d35e01d5c658c0add46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5db28b08012d601203218b1a98f02826b7a237fcedc02e8221cac8936b526d73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3487bdba126c8a24fe522f77492f41a1c7c338db02b0a5d674f41ba506cca8c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "069e5194da136493154b590703e424390984c67f0704479576e2a584789f7334"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "016c7c2ea0f71f6079af477f649c989d3dc1a9a5bdb9cf76a2b781281efe9de6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff012f42ad627145f6b19023b0f6dd75c82efcca65509911f285b3c68715b7c9"
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

    # probe-rs completion forces the use of the --shell parameter in the middle of the command line,
    # so we cannot use the generate_completions_from_executable function
    (zsh_completion/"_probe-rs").write Utils.safe_popen_read({ "SHELL" => "zsh" }, bin/"probe-rs", "complete",
    "--shell=zsh", "install", "--manual")
    (bash_completion/"probe-rs").write Utils.safe_popen_read({ "SHELL" => "bash" }, bin/"probe-rs", "complete",
    "--shell=bash", "install", "--manual")
    (fish_completion/"probe-rs.fish").write Utils.safe_popen_read({ "SHELL" => "fish" }, bin/"probe-rs", "complete",
    "--shell=fish", "install", "--manual")
    (pwsh_completion/"_probe-rs.ps1").write Utils.safe_popen_read({ "SHELL" => "pwsh" }, bin/"probe-rs", "complete",
    "--shell=powershell", "install", "--manual")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/probe-rs --version")

    output = shell_output("#{bin}/probe-rs chip list")
    assert_match "nRF52833_xxAA", output # micro:bit v2
    assert_match "STM32F3 Series", output
  end
end
