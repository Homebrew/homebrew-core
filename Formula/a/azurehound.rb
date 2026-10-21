class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://github.com/SpecterOps/AzureHound/archive/refs/tags/v3.1.3.tar.gz"
  sha256 "75337077b7f2fc7c61dc92c266c11a693db9e84d4d0299fa667114ab33c7dd11"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8a2321fdef0013b8c7943a5c5a3954ecb58c5ff5027a6c383e003771a4e2cd57"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8a2321fdef0013b8c7943a5c5a3954ecb58c5ff5027a6c383e003771a4e2cd57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8a2321fdef0013b8c7943a5c5a3954ecb58c5ff5027a6c383e003771a4e2cd57"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cc1f6ebafc2c11f39358e625f75983925362a4092b2401709eaa08bdbf45b086"
    sha256 cellar: :any,                 x86_64_linux:      "00eaaeb77e3bd192804df0a71748f51e93f1a9ab173d6878e13c6f0ff587312e"
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
