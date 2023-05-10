class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.22.tar.gz"
  sha256 "274b3379e37daee40eceb581f72e873a53ff9e5bf881f86b168947d9203853fe"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86b33232ae65303a8f23fbbac4ccc7be5cf4831551732e8a9dbac76f9d6ad6e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86b33232ae65303a8f23fbbac4ccc7be5cf4831551732e8a9dbac76f9d6ad6e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86b33232ae65303a8f23fbbac4ccc7be5cf4831551732e8a9dbac76f9d6ad6e0"
    sha256 cellar: :any_skip_relocation, ventura:        "2442c6a49f9d8aa6713070215a142eccbf87a8c43cc305e23026760e2a32ed55"
    sha256 cellar: :any_skip_relocation, monterey:       "2442c6a49f9d8aa6713070215a142eccbf87a8c43cc305e23026760e2a32ed55"
    sha256 cellar: :any_skip_relocation, big_sur:        "2442c6a49f9d8aa6713070215a142eccbf87a8c43cc305e23026760e2a32ed55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2249b066bb9ea2d3a4c3d80cb51874855ac6c151f15497b5ce6a35cb24071122"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"

    generate_completions_from_executable(bin/"infracost", "completion", "--shell")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
