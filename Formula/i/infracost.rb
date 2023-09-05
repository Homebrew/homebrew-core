class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.29.tar.gz"
  sha256 "d74e32dd75b132d27d3d42ce345caf020c6a6e7e061c72f479d52307bd21d691"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f34e9cefff5e006be0a508d7a67258af15a14186c43c6f08560ab364065ccc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f34e9cefff5e006be0a508d7a67258af15a14186c43c6f08560ab364065ccc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f34e9cefff5e006be0a508d7a67258af15a14186c43c6f08560ab364065ccc7"
    sha256 cellar: :any_skip_relocation, ventura:        "e2cb7454fd3568d89bb9edd1b541ac33fc8d69852ad5c264d4ab9f9f6530e1ed"
    sha256 cellar: :any_skip_relocation, monterey:       "e2cb7454fd3568d89bb9edd1b541ac33fc8d69852ad5c264d4ab9f9f6530e1ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2cb7454fd3568d89bb9edd1b541ac33fc8d69852ad5c264d4ab9f9f6530e1ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "357687efb9efae2bcf54d5c332159c32f2edc9717222aa9eb1dccef288de62d7"
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
