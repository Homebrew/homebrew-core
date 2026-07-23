class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://github.com/SpecterOps/AzureHound/archive/refs/tags/v2.12.2.tar.gz"
  sha256 "391306c47d9b9a132bc71283d9e03ef3b63b9ffbe1cc4cbd4b0b0efb5f6788b2"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "184096bc43e1318305cc01d2179a3cfcd02d372c1455cd93ac757a5070f3ddc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "184096bc43e1318305cc01d2179a3cfcd02d372c1455cd93ac757a5070f3ddc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "184096bc43e1318305cc01d2179a3cfcd02d372c1455cd93ac757a5070f3ddc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ad2cdb15b5742da12b04c697bf26663d25f314e39c5f542047e7ce3258a7aa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c31a889b1018fc02156800d0c62af7de4016ede04503cab5341a2c9da628e072"
    sha256 cellar: :any,                 x86_64_linux:  "93c75362cd5b2ef4d8a1141514122bcd0efa9ab8808d5e92b8b0cef868d6376b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/bloodhoundad/azurehound/v2/constants.Version=#{version}")

    generate_completions_from_executable(bin/"azurehound", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azurehound --version")

    assert_match "No configuration file", shell_output("#{bin}/azurehound list 2>&1", 1)
  end
end
