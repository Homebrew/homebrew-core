class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.13.6.tar.gz"
  sha256 "c88629c3cdd91b31180fbce14e0c1066bafb6786171b48925672db1c5031ebc3"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7403e491d4d272438689f462dc416b0adf0bffdb0fb3daf48635b4c389bbec9a"
    sha256 cellar: :any_skip_relocation, big_sur:       "38cbe9be4beb802c5dfd544737ee78bd64d5f18884651268da7dfa87a5570f56"
    sha256 cellar: :any_skip_relocation, catalina:      "6ef4af8a3d1625896106ad87d9b961d9728b26cb53087d10784929993a71e991"
    sha256 cellar: :any_skip_relocation, mojave:        "826cf6b6c51ddd3ea9978209f74101e5dfc129523014286dd4cc29c3a1063a0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f132e58651f6c1cb7c78298738938ba7489c33b5b0f856f9b6e8ae9231de05e"
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
