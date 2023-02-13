class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.11.0.tar.gz"
  sha256 "19f8276340ac5616c3b7b152eb483663ef524c5a5c9eac2bfdcc3a7d205d397a"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fdab7dd7b5647204319bcefee7a8fa7e30807c7712de8ff9a9f1831ef2cff66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5536577bfd8caa617e54eeb1f9644d0ffef7d02c980720ec23fabd398900e7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da5e687294e60c22cf9bbf4e7b48f187f8b09a6682e1566e62b8642680e7b33c"
    sha256 cellar: :any_skip_relocation, ventura:        "c35983779d480143b31c31d213291310f4cafd53ad20a6cfb11628bd89863459"
    sha256 cellar: :any_skip_relocation, monterey:       "2dd79c958a59834f7dae5491cfe8fa3a7f1ec30ba61eaa016df2a5dac05278f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7d44f48104a3ee247210970c99fb17a2505bf27bb357f0c4612eb257d49692e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4d59059bba71e15f37ab793c1bec7e30f2a2d9842087637dc87ba196f77ea28"
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
