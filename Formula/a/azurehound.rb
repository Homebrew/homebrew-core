class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://github.com/SpecterOps/AzureHound/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "719ec0e89d8c1cf84782bc9cc856e54fbe16dfa108bffa639433a5b30e0d23a0"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c219c34b4b97251da87cd3b561329828c3afc6a74548595f010c10535f9549d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c219c34b4b97251da87cd3b561329828c3afc6a74548595f010c10535f9549d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c219c34b4b97251da87cd3b561329828c3afc6a74548595f010c10535f9549d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea125c4f13a37b63dcdffe88e0244d5dbc4d7b5fa4ea52bab0de4f376537a698"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ed0bee508e20fcfe2cdda934ad87e8416b0b0e4011a70a04293af5bc496c536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a26a61a72705de61a1050441c6f725dcd26d247607676ec41d8153c9731460f"
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
