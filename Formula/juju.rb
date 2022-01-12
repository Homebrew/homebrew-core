class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.23",
      revision: "b9b2dc63924d8c503fa6b6c108168905e9466ca3"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d89aad9814dd7c55e75a00fdbc839a40cb3a52ec869e043f463846c2fa8817ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69d1149fc2172a658bee8a3d16d10820fb29fba40f0d2ce2a01c6328b78a53de"
    sha256 cellar: :any_skip_relocation, monterey:       "bfeba667aec3164ef310c53d6b9b200f9e69529e7a0ff8ce8357b9f557c593cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "388fc8bb53572305b3bc46995d8b93e2a19b1f32c0c2ede08203d9a1fb9ccd5d"
    sha256 cellar: :any_skip_relocation, catalina:       "705e5449dbecc16fe21d0a01f85e0330be879e13277d9b16ffee3b659efecdc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2da99d9783d2e27a16c49e68c646bff0183c8fee9c0054a9776354407fc89afc"
  end

  depends_on "go" => :build

  def install
    ld_flags = %W[
      -s -w
      -X version.GitCommit=#{Utils.git_head}
      -X version.GitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ld_flags), "./cmd/juju"
    system "go", "build", *std_go_args(output: bin/"juju-metadata", ldflags: ld_flags), "./cmd/plugins/juju-metadata"
    bash_completion.install "etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end
