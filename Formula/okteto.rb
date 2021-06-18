class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.12.15.tar.gz"
  sha256 "05e898b9cf42e2a847ae9ccf63cb2ef9449b1e7d4b786ebf13054b790fea51ee"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7c80e23a88c0e6bed9cc5d1a6d2fc2f201a59122518d9fc2b70168b7af0c8128"
    sha256 cellar: :any_skip_relocation, big_sur:       "1939b6dccf1fae18b29a9bd55c7481f17d0b76c064fdb35d585413a6898fa31a"
    sha256 cellar: :any_skip_relocation, catalina:      "fd539d1d700e240a600de71e7ff3cc4471d54dd73c5b6ce5c140f1035d8b2906"
    sha256 cellar: :any_skip_relocation, mojave:        "f14d1cd2d974afbc572c1626280bc6f720438ed01c283938ec2fabf906cc8a38"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    touch "test.rb"
    assert_match "Failed to load your local Kubeconfig",
      shell_output("echo | #{bin}/okteto init --overwrite --file test.yml 2>&1")
  end
end
