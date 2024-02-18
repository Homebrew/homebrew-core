class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://launchpad.net/juju/3.4/3.4.0/+download/juju-core_3.4.0.tar.gz"
  sha256 "2884f03b17ee0344f2e31e2c31f8df1008465706ad30e439dc4fa283c659501a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f9b44497131fe53033e88538b641f75e7b66491dc274e6eff2904ed03396bb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e73d9be28bd1ccc21b4fff519af604972500da685e6658b93ca37b5274be1ba6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc3c68cd04f26b66d49497ee241b01e6e8ef01841cf7941caa7f1b20a395c08f"
    sha256 cellar: :any_skip_relocation, sonoma:         "630e752d8c4752a6166b926d9893ec37013225b07723812605fecf8eaea93a2a"
    sha256 cellar: :any_skip_relocation, ventura:        "520e120cad6ea64d934ee54893886d5bd35a0c0f3539e47789af240fb8d17d33"
    sha256 cellar: :any_skip_relocation, monterey:       "ff9be74efd004671fb1f479816b11223d2293bdf4d4ec75c1c7c1e0dc7663fe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41af376e8212cd4e206c7db729f59349e21b059214b6b7a7bc0faae73ae4c1fb"
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
