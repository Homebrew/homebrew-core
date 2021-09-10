class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.13.10.tar.gz"
  sha256 "b50bfebb8d1cad07411624c3c4946a140f32c5f64db0b2e5b393c1f5d82a860e"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "01cdb4fc7ca14324fc88fd4a9bb3a457815a58f3ab3b952a2fe92bdf8536e276"
    sha256 cellar: :any_skip_relocation, big_sur:       "7ed993aea5d84a466f509e49010a37943ccfb4c76201fb3f4d1b46b5a50b270e"
    sha256 cellar: :any_skip_relocation, catalina:      "a227a63909907f8fc88d116767faa6f1ccfc5e59bfc5cb4359323208df5c756b"
    sha256 cellar: :any_skip_relocation, mojave:        "103f8eeeb69f72545147b9b25aa509db4290eb94a6f3f86b604f1a4a51f41b37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4128995d7421e7d9289343783d21b21cbaa4ce203613e0b27c73b5dda213422"
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
