class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.32.2.tar.gz"
  sha256 "f69a7d6c49f051b065028654e8011ec738051815a609c500e21dc7bdd09fd155"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "419661b7681aab25e53ed077c60b12d1c587d735c55adec9670107c5ad8c9234"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e47c95a54f089b76b83b7893b14cf2d5a3112229261e23093d1a415e3f15afd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "706644fb89b3a1949f331f870678f5d4b415b1b9678cb6a4d3c83f6d7b764731"
    sha256 cellar: :any_skip_relocation, sonoma:        "836cfd6c9ba4c3a3f9ea477778e2f61bf54e513ce635d0b237105eab0d2663f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a654663d48764aa857ed2cac3a8d59c42ba9e085aed13df1d442806f6d3a7a2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89e614c88c65c1f7b06143009e2fbfb7a8cf99fdaf444f9a0fe9b6caf6602e79"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
