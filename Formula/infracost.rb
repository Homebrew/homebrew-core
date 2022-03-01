class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.19.tar.gz"
  sha256 "c2987aa501e1049f57f6187f00637211cd6faea724db0eb3a71af260a40b68cc"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8d7d1fe15e0148d9cfa9b9aaa9deed5e2d8ab9373fc06ee54b3d69afa63b0f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8d7d1fe15e0148d9cfa9b9aaa9deed5e2d8ab9373fc06ee54b3d69afa63b0f4"
    sha256 cellar: :any_skip_relocation, monterey:       "21f6542ebea56480077e1aa09a26c7d6978c6d604fa93dfe3f4671da4a0b1722"
    sha256 cellar: :any_skip_relocation, big_sur:        "21f6542ebea56480077e1aa09a26c7d6978c6d604fa93dfe3f4671da4a0b1722"
    sha256 cellar: :any_skip_relocation, catalina:       "21f6542ebea56480077e1aa09a26c7d6978c6d604fa93dfe3f4671da4a0b1722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1c03c73175bc940b8754120caa58b1ffbc1c39613460250b569e52db977ad6c"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
