class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "b836ca77640384716fc6a8188f89cfbe6af9c92bc947aef5ef767e6854b37fde"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3f0fb44fdf97d7212d16ad9fc3c00cb8c0182cefe43d67b1f7d59e7bfdfcaae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c2afcc206f8be6839b36ed9c6b3c5975a3b97a6c9a7b752718aa899c7857ac4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d00b45206d06118a73643e939ad46d8c522c97d9186d17ac5cd4b7e9f7dd7eb"
    sha256 cellar: :any_skip_relocation, ventura:        "63d0684c4ffc17c08507c19b686d2fbf1ae876574bf90338ae5b0c388efac508"
    sha256 cellar: :any_skip_relocation, monterey:       "f088fdfa0264aec90e18585be1261ad8bd9a598a02b8212f1cbf0db39e48fff9"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f819312d5cbc060a3af0bf2514fecf2c7a25308feeb42a8f690f7626c27576f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "927a39cd2c830c66e28394ee825070ba0e77708a4f0d5d418a5f2ec5a1849926"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/buildinfo.tag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/coder"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/coder version")
    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
    assert_match "postgres://", shell_output("#{bin}/coder server postgres-builtin-url")
  end
end
