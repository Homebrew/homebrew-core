class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/1.11.1.tar.gz"
  sha256 "8f90a1b83d88f0a7c383da7b8dfc7c606400f6e0af8e98daa687b8e67c265d20"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f4aa1cc2aa56f0a8e7cad0f3b5bc0b81ff00a345932280757bc2df236063269"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60bb3a9a3cb8c529fc8b4b36a9d649d6612cb838ada663a7cd01395e11b632ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85bc58d4c1b12cdd9b47773e8f30833fba5e8296944b101e6b820cd761de202a"
    sha256 cellar: :any_skip_relocation, ventura:        "70e0c5bab9a1c9a208343bfb2c91eaa0f4712b82ae2cd2cd8350408a63bc2afa"
    sha256 cellar: :any_skip_relocation, monterey:       "6504a865d2a74de5eff6b102741b058da8ec8a721db33a6e404b9e0cd6415f08"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f73999f557d923f7c523e0d62db8b09696c1c38de55ac24b65e08b7675939bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea5c9402c269dfc610b631a8550cf0f6c3e5d0313124b94df50556a77962decc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/kubefirst/configs.K1Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "createdby: installer", (testpath/".kubefirst").read
    assert_predicate testpath/"logs", :exist?

    output = <<~EOS
      +------------------+--------------------+
      | ADDON NAME       | INSTALLED?         |
      +------------------+--------------------+
      | Addons Available | Supported by       |
      +------------------+--------------------+
      | kusk             | kubeshop/kubefirst |
      +------------------+--------------------+
    EOS
    assert_match output, shell_output("#{bin}/kubefirst addon list")

    assert_match version.to_s, shell_output("#{bin}/kubefirst version")
  end
end
