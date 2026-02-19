class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://github.com/SpecterOps/AzureHound/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "42eed0da4ace2755fb79555700d44056e9ad939a422c4029608c58dd1df94780"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b62133827725fdee3a7af9d27a2f30d4e630a0f95efe86cf7583990201bb56f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b62133827725fdee3a7af9d27a2f30d4e630a0f95efe86cf7583990201bb56f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b62133827725fdee3a7af9d27a2f30d4e630a0f95efe86cf7583990201bb56f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f1fa2d056d22dd16770be0b31a1850b107d5312a31141515e1530107016bdac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b2f2f9931d7e2afb78f536c085b4fb1858b9a1c63d6f4dfbdf6013928aa6421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df5ef2d2c2df8df3cda130e237fe2a7967888c74277d2a537c5475c7037ce86a"
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
