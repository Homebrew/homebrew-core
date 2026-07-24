class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://github.com/SpecterOps/AzureHound/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "8f764670edb7c3bb79af0d82a2c329d0ebb689285b10725c357e0eea66e3bebf"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef68b4e66f709bf585191c887e58ad5283efa00cfb575838fe040e64274f0a7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef68b4e66f709bf585191c887e58ad5283efa00cfb575838fe040e64274f0a7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef68b4e66f709bf585191c887e58ad5283efa00cfb575838fe040e64274f0a7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fad40c92356b53a4b713b6e16dd8c9de3515b6e8c60cc57cdf11139a70836f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fdb4c7408e22006689771e1f6f160275b18e77b0dcd1913d4d63589834bc8d0"
    sha256 cellar: :any,                 x86_64_linux:  "b0292c00b3dd00585390d260e7615b716199e9233f6fe48648fc94febd15b9c7"
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
