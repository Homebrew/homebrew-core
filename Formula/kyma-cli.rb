class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.10.0.tar.gz"
  sha256 "604883fdba2811f95050466024ef3569064724d866438f04b93a5f776174ad00"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a58b2a238e7aa45453ad8c604f3fc6ba470fdfb495b709eff9f0af7f4a2dd3c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b7b6a609e646fab2cafe09fb86bb128871a8f3b9704878f03319d1ea9317bbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d368eea85e69d380343f49ccdd03cc9779d63e4bf7cd7920d6d1b7a8bdb4656"
    sha256 cellar: :any_skip_relocation, ventura:        "2e122edcab190dcdbe4e7f4b2651ba9f8791aa1ecde281878778e173c610ecc8"
    sha256 cellar: :any_skip_relocation, monterey:       "0632590673c6886584a226a109ca8043c73458c2985dc360ee6d751eaff3e82f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4035bb699809f1550a98a222c022a84fc6be2847cb9f551d28035a57bd5bd62c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aec541877e39bfe41312fa1f2ca5952e4efc7fc87a6857e58f013c3e3aaaccfd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags: ldflags), "./cmd"

    generate_completions_from_executable(bin/"kyma", "completion", base_name: "kyma")
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
