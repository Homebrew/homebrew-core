class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://github.com/SpecterOps/AzureHound/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "ad4fd0676dbaaf1502ad8f7b29835002e3109f9ebc0eae29000985bc8b072672"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44ed7046767e7227e327ef24e98468b4364466ea0f97755351f0a7c4d1abe53c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44ed7046767e7227e327ef24e98468b4364466ea0f97755351f0a7c4d1abe53c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44ed7046767e7227e327ef24e98468b4364466ea0f97755351f0a7c4d1abe53c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f1d6ef932b450a40b451a6d1c7d97a5665b9f4123e232fc2b5aefd87d7c7928"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceca60d109fdabdc903b168319c46424d1ceeb949985aa279f21cbcd36a97b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84f73d1cb774e82508dcc34a0f86bedc5bd5259eefb1aa7b89a4b93d7c470376"
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
