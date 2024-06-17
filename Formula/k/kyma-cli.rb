class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/refs/tags/2.20.4.tar.gz"
  sha256 "c36f05ceac8754dda45ca1f8caf0caa48b5f3660628151d618aec0acc861aded"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f37956eb063a2cb9ec326ec8aeeaf5f2b9dd46fcae7ffa949ca9521f8f65a78d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcdde026a22bcd521f7a723915d36a92a2cb074538307055ada370c6b1818614"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07e4a5bedabf6af25dc396dc5b346ae977c595b91140041c6152f28ce04ac9fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "22e8bfdc935267b32fe7899762eb98dbd200716be663f0bb68383e222a667178"
    sha256 cellar: :any_skip_relocation, ventura:        "ecf96295b7d8a92eff4c7df434db78fb03387198d9e3ee5e9bf0f5305dd47017"
    sha256 cellar: :any_skip_relocation, monterey:       "f8944a3870709e8d5ab6149566e3979548d3b118a3c595c81d4c18e726463a20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e605f98de9b1022de26c4f729e43f617591ba6a4b7e99ed9c49a5568de35189d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags:), "./cmd"

    generate_completions_from_executable(bin/"kyma", "completion", base_name: "kyma")
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 2)

    assert_match "Kyma CLI version: #{version}", shell_output("#{bin}/kyma version 2>&1", 2)
  end
end
