class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/refs/tags/2.19.0.tar.gz"
  sha256 "46b9fbf8fd619fbdbe92cfe1bb1dab188bb2fb29538339b8bdf292d1521722ba"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45bbecb927ae8acd634a215d74c68e4a3c84385cdbf09d266d57e0705e51ce28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21f92313f4ced1419522981bcbf899b9a1befae1a9ab9b0bc38477a6ee23bcc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42fa2d733e16fbbdf331d664e639cf17289d7e973bd71c1c329df17b53989087"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a688065a3506c58be4433e4f4b32e2444ddcdbdbb20043a019609b4568b3611"
    sha256 cellar: :any_skip_relocation, ventura:        "c7edc55478395c029477103214b043fba2b1a258497a85a530489bcddde7b7b6"
    sha256 cellar: :any_skip_relocation, monterey:       "416ea55192556832ffc6605cbf376b1e7fe677ba6351b2414f8dc18ed010b518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e6635c3603d89ad73869c9d7c60782f76051d50be3e66eb994a0f3c664a8052"
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
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 2)

    assert_match "Kyma CLI version: #{version}", shell_output("#{bin}/kyma version 2>&1", 2)
  end
end
