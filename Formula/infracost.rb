class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.16.tar.gz"
  sha256 "f22776d297465ecd1c00520ee4f138d68d9e765c380e020096484d9260806e41"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e86567448661737333dbb278e50caccaddecba83a1d3476594d2eee38c885f63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e86567448661737333dbb278e50caccaddecba83a1d3476594d2eee38c885f63"
    sha256 cellar: :any_skip_relocation, monterey:       "678bddd844510552180b922e145d8b8f6b3030ab2dc4bee43281424c727e08e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "678bddd844510552180b922e145d8b8f6b3030ab2dc4bee43281424c727e08e7"
    sha256 cellar: :any_skip_relocation, catalina:       "678bddd844510552180b922e145d8b8f6b3030ab2dc4bee43281424c727e08e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcbd86bcb50cc6d6e984ae70a8babd29b52698eea825902be100e02c2285d804"
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
