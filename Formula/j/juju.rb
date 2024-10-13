class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://launchpad.net/juju/3.5/3.5.4/+download/juju-core_3.5.4.tar.gz"
  sha256 "58eb899bb4453c5beb07aae0c27f038d55496d0f026a37aa1e5c5dcf50f73a56"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d03348f3ea3a032b5da3f88d083930b46d1287e781784c27fc3df0344bd97922"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dfcb9ee2ac2ef4dc88073955f8a814a299d5b35b4257f4a66ce77b328eb8b98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1f3c2bc55bc47f6713b8b615f8aab0b9a7e20e6fa1f5b52d1cdaadca20d5da5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d83493c3517be39bee1c9fd0b57563dc29190bc3c2cc0801b88f42646c3724a"
    sha256 cellar: :any_skip_relocation, ventura:       "44c549e451bf9377f3d01c1c9d6850f04f489567fa9905b54a3a7c6bac46fcea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ee9b9154d2c4c3aea9836167ec07f2ffb49de6f74497122d78b807cde38680f"
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
