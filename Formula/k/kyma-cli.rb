class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/refs/tags/2.20.3.tar.gz"
  sha256 "0da053a6ac4b0b83fc052380fb43704fa69be87dc80bb0a3f743cbfbaf295011"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "981c22ebbb6a6dab6d0ee66f45d7feb10cac9cb66533552ce88fa1554226f7ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d415507384471e088ce6d154141971caaf7992ee94eba2bbfa10b6c06100ce5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c3e596b571a218275839d090ba1de70dc13dbe808d23f4e625b1a7f09f331eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "c295b47ef4ce115a3214705ddeee4d816ec8dec0495d1465fb7c8933208cc077"
    sha256 cellar: :any_skip_relocation, ventura:        "f6c7378d30ce1c68e08de4d5bc4f019c192e348b289cd8b8c0dc438ad327f07b"
    sha256 cellar: :any_skip_relocation, monterey:       "77c2a70793aa4197ad0128dd80d9a17cc8cfb7831c3b8eb23f744a3450c4f6a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92c6a1810b7c08d2ee9bb43a8c6c13a7bc0dc759a0847257d94e795071cd12fd"
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
