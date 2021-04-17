class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.12.7.tar.gz"
  sha256 "28f009ed6be8b4c497de2a225a00c653acb40ce16bd9ebd1283a45388d188ca8"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c3cc6eecc2d001a8088d08e1976a3c7a37b0dc2a48d56c7fd36cf3892849bf75"
    sha256 cellar: :any_skip_relocation, big_sur:       "d1360aa4ce80650d966785b6a9699c70e4c58666c210b2a79357f27258b818df"
    sha256 cellar: :any_skip_relocation, catalina:      "93f622c23fe79ba0c4310f2f55ba1f4a0988ffd32af9033fa0681cb7a06f33ee"
    sha256 cellar: :any_skip_relocation, mojave:        "6f30f3716283ebc61573b38c429304f82324e8b13bb431008119513d8f1078a7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    touch "test.rb"
    assert_match "Failed to load your local Kubeconfig",
      shell_output("echo | #{bin}/okteto init --overwrite --file test.yml 2>&1")
  end
end
