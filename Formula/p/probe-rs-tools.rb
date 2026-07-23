class ProbeRsTools < Formula
  desc "Collection of on chip debugging tools to communicate with microchips"
  homepage "https://probe.rs"
  url "https://github.com/probe-rs/probe-rs/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "9c4ba2046d4709f6a07e47933b1aa7edaf72a4d0a9f482b81d81798879070229"
  license "Apache-2.0"
  head "https://github.com/probe-rs/probe-rs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f662812458dd2e5fc4d839d875f0612a1e75534e645710bc74a5641d4fba0250"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbdf7481e300d0e28aa756ec20d1bf0c32b66148bc697c188d5977226d58c756"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3e4a973d21b9b4391de22b9b53041e5ccb4b9851c60b19113778aaa386d2e27"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e6ab7ce96483065bf33540fba35dc66ea2cdf2e5813c08a08c87119c1fac043"
    sha256 cellar: :any,                 arm64_linux:   "91d1a70e174345ee2e621a97a4cf4e557b2e01ace22ae7e29800e86883ed87b1"
    sha256 cellar: :any,                 x86_64_linux:  "caa09152d35d4ec991f19f08e5aa65a15cb3dc003e7f81e3228c096d05b622f1"
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

    generate_completions_from_executable(bin/"probe-rs", "complete", "install", "--manual",
                                         shell_parameter_format: :none)
    # clap_complete only recognizes SHELL=powershell but our helper sets SHELL=pwsh
    (pwsh_completion/"_probe-rs.ps1").write Utils.safe_popen_read({ "SHELL" => "powershell" },
                                            bin/"probe-rs", "complete", "install", "--manual")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/probe-rs --version")

    output = shell_output("#{bin}/probe-rs chip list")
    assert_match "nRF52833_xxAA", output # micro:bit v2
    assert_match "STM32F3 Series", output
  end
end
