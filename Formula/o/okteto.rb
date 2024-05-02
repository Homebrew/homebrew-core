class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/2.26.1.tar.gz"
  sha256 "f873a0cfb7a43b92672745e404c1aa3b72840eb8399ffdb93befd3389ace215d"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ad395f4c68962ab73a8e5363d5b48d04e807105fd1b582084736f01035903e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b32421224f17899bc5196098a6381246c857bb859e2f7cef16e50197f9e2bc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0b3d5ac55e17e6649169a2797c20c55e9ecd2c1b7e250c5e475e9f8c891bed4"
    sha256 cellar: :any_skip_relocation, sonoma:         "76d30f9237c58156403cb46c9322c9416bdeab086dea9d4724a36a04d0b1ef31"
    sha256 cellar: :any_skip_relocation, ventura:        "15ae276ba63b5411ceb642c2546053e265fb3025d0047b1c19700bc3c970f28e"
    sha256 cellar: :any_skip_relocation, monterey:       "6e674dde6fcfb569e770e0cd59b542e55b34a13f8a281a6b25992cf9f8779a69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "202e887dbd0b5d2d33ec7b60840f16b12db3d286cbc49346a9fcdcfa3bd8ff7f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
