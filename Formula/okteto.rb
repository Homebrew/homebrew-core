class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.13.4.tar.gz"
  sha256 "99d7be227edb80c20fb4326ecd7cc735d1cfcf8fe6d6f6d61f8b997dc331b582"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1e7e6947ecb9ef56116466c60bbf956a22bfcdc7bb369db2510eeab0ae051013"
    sha256 cellar: :any_skip_relocation, big_sur:       "fc329cad94c67f02902e1a4e4c8388f780a390ff27c1ed68015d3a2490568005"
    sha256 cellar: :any_skip_relocation, catalina:      "e6e5ccfa4f8c9451dfa4f879cd0d1f6370902f203939ec2ca1be0a5b560f725b"
    sha256 cellar: :any_skip_relocation, mojave:        "2119fb09239705ae39f8e87fd89ef98b03f03e2bebddf9c88c22cc4452e0e841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0586436c4482c5523e8042948ea948955b7d3390be68a326a0301f567ed415ef"
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
