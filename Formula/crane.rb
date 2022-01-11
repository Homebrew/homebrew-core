class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/v0.8.0.tar.gz"
  sha256 "2ed9b9da9954205996eedd17f507dc56f39de66b2e9b35eecd40b4bebfdddcce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9354917c947b767bb70b23595745ec2d30904fb5b49f75c837639118a0717e97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8144f5a9bb744b5e2b061cb9b3b1ce38080855586fa380f8887c508106aa3c3d"
    sha256 cellar: :any_skip_relocation, monterey:       "4c0bd2c38cbc6718683f0e64c596252254de4179a0e01354ba54f6930ac236ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0678db71d81a4a84ade7aed69c89f849133da255ebeac7d53f5592e0eede999"
    sha256 cellar: :any_skip_relocation, catalina:       "209dfd75f8c9fdfd699477fa4595a44bc8b6d59e74439b70da5903d297c2c6cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c44938d3423dd8b967261c890f165f3563c36658a551a6b0c8c21372a8a733e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/crane"
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end
