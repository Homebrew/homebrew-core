class Kubecolor < Formula
  desc "Colorize your kubectl output"
  homepage "https://kubecolor.github.io/"
  url "https://github.com/kubecolor/kubecolor/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "780dc28a7284881da6e14cc2a9eb33f4be19a0d84c5c9402702c34c720e07ad3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad28aba077f5bacf884caa340cb91e0950c69fe7de459e1223a2e8b5733a9fa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b99f1cbf4faab2d80dcb23d206fb3d66cb6feb68925769acd11c315a8fcbb1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7eaa3de0ef0726db8368c7c3fa23531a8b139cbbd782520697f8a527710a8fe6"
    sha256 cellar: :any_skip_relocation, sonoma:         "97f7423e543ebd63a9edb85ce2e25eb74f8e1922c8dfdc597bde27fa79e92379"
    sha256 cellar: :any_skip_relocation, ventura:        "0618d7b4256db786affb7068af90d1f012745e99ff1c50982d9ed5756d1600ef"
    sha256 cellar: :any_skip_relocation, monterey:       "455a565f1f06a6b9206d33fc45ea0d04d32c807c16464f50f914efd6e5fdbcf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "143d7336a3eb51e8733bf737c944d1969a0d789e90ed961dae0128df7318cfc9"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    ldflags = "-s -w -X main.Version=v#{version}"

    system "go", "build", *std_go_args(output: bin/"kubecolor", ldflags:)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/kubecolor --kubecolor-version 2>&1")
    # kubecolor should consume the '--plain' flag
    assert_match "get pods -o yaml", shell_output("KUBECTL_COMMAND=echo #{bin}/kubecolor get pods --plain -o yaml")
  end
end
