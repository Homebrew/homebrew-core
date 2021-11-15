class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.14.5.tar.gz"
  sha256 "279eb076288ff0bf60a66b9c3ea4bfb43c1dfb4585f6cc35bec975ab0b67e90b"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93e22f3bb7de483ffa9c2b9ccbaa8da2cdc69e6913cdecafb9541cbc2817811f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "045074b04b466971612f761826bbfb1840c3a5e933b82b006ac46b7d4824962c"
    sha256 cellar: :any_skip_relocation, monterey:       "b384637b8e2ba4728a50b3949a068172c3dbbdbded903fe5a8e4bd3564d83e71"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f9d4979d7f0fe9cedf91f67dc477a06650535cebd46c4ee5c1688a5fa1eb40c"
    sha256 cellar: :any_skip_relocation, catalina:       "4ec418830a4b6c47eeb50aaea9ea66f3f677f8e41091e8c6d6cc31a26021c372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae2b7e9608ed870ba786046020009907a225c45406585ff0bf3d0d38a7fffa89"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "No contexts are available.",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
