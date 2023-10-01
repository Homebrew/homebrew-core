class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://launchpad.net/juju/3.2/3.2.3/+download/juju-core_3.2.3.tar.gz"
  sha256 "a1a44d4b2edb49202bb02fc330fd6b2c01997abba09c5eff3b7798cf38236f4d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1130265f693de69125c75800aeffb53880d5d4b14ed2fed560d070b148bbd37d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3c3b88d8ccc81cf68d260920a6bf33cccecda42bcc74b3b3f705354e635be74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52d1cc141cae792aa9641eb98915f03e0a36ad872cf7ec273dde7f0954a8cdb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b308f8013e9ceb01b3971d75a45799ec5c5909cf4bcad78065b3157beade829"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a91e1eca674b42291b7ea7e1706a0daa1cece4fa232f528f68edaa28fc55c2c"
    sha256 cellar: :any_skip_relocation, ventura:        "d4ca0097cdd2375a6fdaf5dc829f0722ddfd9e7a3a2ae5ccd707b4f8b7cfe524"
    sha256 cellar: :any_skip_relocation, monterey:       "ca8c60a918d8d1c11a125b77bd0aa568cd7ada7f4a3300a547cd80cab7f7ac6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8acc6f5631dca298772139362c2f7935162ee442ca5fe71401f3f3d2123a5bc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35facc52b0e2ba44695088992d813854bc5f35598f60fdc43d41af68d16c3c4e"
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
    system "#{bin}/juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end
