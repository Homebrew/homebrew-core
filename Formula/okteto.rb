class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.14.0.tar.gz"
  sha256 "bda3f6afba7eaf634bec41bf6d7147e02056367f84975d8e90c49ef3b230aa7a"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bf3b8a6a995a2ceb77276e624569b74b66d2b6e06888a9465228c0e2ea52abe1"
    sha256 cellar: :any_skip_relocation, big_sur:       "d903ac730b86d77e4098a2ab8f0809aa1fe3619de117f3fd241cbdad5718d5e2"
    sha256 cellar: :any_skip_relocation, catalina:      "9b765eecc84acd0f3264effdbe470f1180f16739f03a9a4e92db5309f1289445"
    sha256 cellar: :any_skip_relocation, mojave:        "9d85fed99bfa9b3cad7f1be8fc051619dca741a0327d965f7b27a2b50cfd6b95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1178e86bfc7591142ed6914d88ca4d01203bcfc8299cdc98314fc55488212dd5"
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
