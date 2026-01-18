class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://github.com/SpecterOps/AzureHound/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "9fe6e46fabc7ca86553bd9b36f50a269793b1268602737ae1ec56d18468f0bb3"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd69165b7dc544ed3ee6506ea282fe6d226348c160a84e24cb530cbeb3eabca3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd69165b7dc544ed3ee6506ea282fe6d226348c160a84e24cb530cbeb3eabca3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd69165b7dc544ed3ee6506ea282fe6d226348c160a84e24cb530cbeb3eabca3"
    sha256 cellar: :any_skip_relocation, sonoma:        "738de929a4647b5632c3a8f350b5a3e51d6dcdf0641c27f0a90ebe82e17409bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97d88d0e4925fa0daecc3d0bae076859ac4cb6bc25ea0762d0e1de2868711838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "759421d47040d60e7a96c4862841c7a7d8b1aca1abc65bb61ba99b6ea9a3ce73"
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
