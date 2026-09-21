class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://github.com/SpecterOps/AzureHound/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "e8b487e2fa894e6f492a6213f814db946aed9d9f9fa30f0b8f9f127c630aa6b6"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b451499d6f4066007c4dc4c1939ff6c59e9c8b56121a84fef5d2987cc90331c7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b451499d6f4066007c4dc4c1939ff6c59e9c8b56121a84fef5d2987cc90331c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b451499d6f4066007c4dc4c1939ff6c59e9c8b56121a84fef5d2987cc90331c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b451499d6f4066007c4dc4c1939ff6c59e9c8b56121a84fef5d2987cc90331c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f0c79b9b2df8f36336e0ccad2aa30381184f2ab74a2fa2d17215585ac5c74ea5"
    sha256 cellar: :any,                 x86_64_linux:      "d21113350ac49a63fdfc644f8e4a65407ebd8c2b905c70269420c7673264a59a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/SpecterOps/AzureHound/v2/constants.Version=#{version}")

    generate_completions_from_executable(bin/"azurehound", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azurehound --version")

    assert_match "No configuration file", shell_output("#{bin}/azurehound list 2>&1", 1)
  end
end
