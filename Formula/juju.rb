class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-3.1.1",
      revision: "0a2659b7b4f74b0f914e2d150a34724998ddd6c1"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "develop"

  # We check the Launchpad download page for Juju because the latest version
  # listed on the main project page isn't always a stable version.
  livecheck do
    url "https://launchpad.net/juju/+download"
    regex(/href=.*?juju-core[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef1585fe43cc66f1933384925566ca7daf83ef6dcbb8254a3dbbb656e44a3e92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c40a5fc5256a77ea38743b934efca2ddf9486c596298071a5a41057075db6fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba80c519cfe7c7668aa40d061ce4b6e41c9a9234c1281fac588572f7358af825"
    sha256 cellar: :any_skip_relocation, ventura:        "c248fca0c8bab442c668f709d4e9e91b78a5874152dee2d1a20a926cb6fc6121"
    sha256 cellar: :any_skip_relocation, monterey:       "c81c929a27cd628e066e3dbefda6e08b0a1e2d7625e894f3477da7ef54e4bb87"
    sha256 cellar: :any_skip_relocation, big_sur:        "01634fc983931ae3399e33ebe85afd10662934889c0ac735056a61d68ee4bccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e31401a081d3a320098ac090ea7fbfc661849e87d409abaadb16a142ef9a1a8d"
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
