class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.31.11.tar.gz"
  sha256 "872b90294e95c069ca80b6b49e93d533895af7ab79e7de7dff31bf473a7495ff"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "493026014e3419ee9584fab247456bbeed5f6790e10bc3f5706ec3f4dedbda07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae01c958cee96aaecc1d665ba13865a3c9f87e219d3062823a649d5ba69c99cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb997607629d1f8cf0567c26f706ff980e5eefda8da3a662c062873b385cabb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b11079ec9ab53263a2c56b000f6a8dad599896b643d9b1404e6997470f0b1cf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46a8ff4c611a03b6a5e32aa5bb8c78dcbefcee33e80d2835d7913cbb287a83f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "957fdeffd0bc0d76f6a430ca4e1db0eb0eb7efde475a1e3cc540072a85304224"
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
