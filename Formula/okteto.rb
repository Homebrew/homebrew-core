class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.12.14.tar.gz"
  sha256 "8311dba69d15402d11fc9e44c5f29157c3573782327b78be39bd4507d436969e"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b4f0d9071d5d2ca1412f6d9cab8e45a226ee3faed8153de741d86cd2ff58d241"
    sha256 cellar: :any_skip_relocation, big_sur:       "2f2755525e5d7104d47583d126e3ef4a34771942837b2d06db1ed42b1a1874ff"
    sha256 cellar: :any_skip_relocation, catalina:      "1ca42d1104d9a62ea258edb06c409ad1ace67934c8cc346b633d3e46442be8fe"
    sha256 cellar: :any_skip_relocation, mojave:        "db97427b64ea8a3d611bfb3f9c7336997ec5257dd7b31f2fbba5b4203f08d6d0"
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
