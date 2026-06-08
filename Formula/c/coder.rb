class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.33.6.tar.gz"
  sha256 "eadb2ab2758f4a30df43e8a344a220311f9fc98633bc75a9f98dd62096da9ad4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eec5ab3c7e6f76fcaf630eb01296c812fbba91100e252597cda9260160de6835"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d267d6d561c9c3e3d401177fb863e7d14a5b7dd5afd93a328edafc48faa8444"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bef1494f4538dfa2dae332d9c7bde27e259238f787527e27679b75c90c9f2a30"
    sha256 cellar: :any_skip_relocation, sonoma:        "a412322d6a6820f97d8a5288b31466ea88a915eea1a2de0841c6612b48373562"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3400ac6359a34f04571877c92105d8e55bd869a8be83d9e9dda478b1865d2b4b"
    sha256 cellar: :any,                 x86_64_linux:  "9e73078f80284fc287e96d232bb4dd58e19223d3be1e6a64beb44dc79bb0f53c"
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
