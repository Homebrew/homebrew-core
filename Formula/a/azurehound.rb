class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://github.com/SpecterOps/AzureHound/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "8a99ba69dd15c05bc1b85d9234c1de22b02e100a3a0ce605f7d89a569071e93c"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83a334b62de0996744cc7fed1ec39a2b3779353bd6d936e4d8940aa6b646ea71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83a334b62de0996744cc7fed1ec39a2b3779353bd6d936e4d8940aa6b646ea71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83a334b62de0996744cc7fed1ec39a2b3779353bd6d936e4d8940aa6b646ea71"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe314a96a45c94c3c204f8c16128004a11f8daf8ca1bd4e184d891b60951cdd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "827159f06900908bca25d8812496d87d4deb4aefe21985c5323b60367cc518dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "638f98e3c913adf10938a5f4ce73db61d2ca7a6733c5441f6a06dbfe88e3a8a8"
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
