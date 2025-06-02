class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://github.com/SpecterOps/AzureHound/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "133c88761831991b237de0aaf4aaa2f15190afd4ee85ffed45a7c8caf523873a"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f2df09ff9b302a1dcdbbea7b01c4dbb087fb11d88ab001400c1adf15bbc60b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f2df09ff9b302a1dcdbbea7b01c4dbb087fb11d88ab001400c1adf15bbc60b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f2df09ff9b302a1dcdbbea7b01c4dbb087fb11d88ab001400c1adf15bbc60b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5221e3dca0df8110448a2789e7a63f3f3aa5c04c12129bd499c4c513aa47cd5d"
    sha256 cellar: :any_skip_relocation, ventura:       "5221e3dca0df8110448a2789e7a63f3f3aa5c04c12129bd499c4c513aa47cd5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "184ef4b185b516dc43a13bbf887c985c52d7c712ef730e75a5f957cb8da94d68"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/bloodhoundad/azurehound/v2/constants.Version=#{version}")

    generate_completions_from_executable(bin/"azurehound", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azurehound --version")

    assert_match "No configuration file", shell_output("#{bin}/azurehound list 2>&1", 1)
  end
end
