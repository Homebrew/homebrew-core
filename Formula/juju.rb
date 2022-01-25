class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.24",
      revision: "b9f202e346e8e50445b1d8ec4b78828bf4bb12a4"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d52d579c4e18abb6bae5fa7d46c9ff0630e4aba6e1abc2d9424c4d7ae8671b22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd269367c2bfd06ad006d698dce0595940d6590b2ba34def15182f108f3dbf2f"
    sha256 cellar: :any_skip_relocation, monterey:       "dadb14964b5790f0611f1007f136d2afd0439eeceef816551dd949d7425bd392"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d6557b983ad9dddd055ea439e5681409705effa21b714a053f3478d00ba25f7"
    sha256 cellar: :any_skip_relocation, catalina:       "fdf1606468b9713f46cfc22c217c406026e5fc9802020be5c8a09382706c9b41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7814e0a08048357785f70e698322f42bf4522b9cde251f841ae31806d8139f8d"
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
