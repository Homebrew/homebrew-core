class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.11.4.tar.gz"
  sha256 "a1e98bde8c20556e35bcf928dedf4ffb0015ccc98cb33e5dc322d6ad7029b2f6"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "33131aa37496be8d211d92e04a331ea98725ba8d5f981f30ae93e4c157255439"
    sha256 cellar: :any_skip_relocation, big_sur:       "b7c9c9f4a8c7d149f12818d7274f5fd597cfa6677bcc05b561288481c9bec467"
    sha256 cellar: :any_skip_relocation, catalina:      "7063f97e6fa7707c0e3068b7e3d8bf8b2c798f36bba980b39aa4b1c8860e94d1"
    sha256 cellar: :any_skip_relocation, mojave:        "ec2501dfc1f481f367f3e0732cf24cbd4c81f802511e6c2c5b5c469f259c7630"
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
