class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://launchpad.net/juju/3.5/3.5.3/+download/juju-core_3.5.3.tar.gz"
  sha256 "1df66caf585b5d7dbe24d78fb8aa050815b08560d263cf8b765cc58b3334e533"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cabee6f5360108f503122d59ea9707478336548f45565750610236388242052d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e03fcffe116dae6887ae270ec0232e62914abfa83c3e8c21f939cb605e69744"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a82b1b52912863f2f1c49e3ef20f9619fadbcac1ceadff269887c9520cd756ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "22dbc433c30688348c224dc66824865448aae600571c832b10b23c923c1d1a07"
    sha256 cellar: :any_skip_relocation, ventura:        "a91d3b093e581a44e0a512da5ecf9cfa5d5866d8f7e3f6d93d7df6d97928e47a"
    sha256 cellar: :any_skip_relocation, monterey:       "801f35f7a169acd69461306bdf8772cbcd14eef8924684414c9ee319700446e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "260ec3d6921a82bbc64d7b4d96c64ab2cc40111b050ea0f7182e6ecb9af70f28"
  end

  depends_on "go" => :build

  def install
    cd "src/github.com/juju/juju" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/juju"
      system "go", "build", *std_go_args(output: bin/"juju-metadata", ldflags: "-s -w"), "./cmd/plugins/juju-metadata"
      bash_completion.install "etc/bash_completion.d/juju"
    end
  end

  test do
    system bin/"juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end
