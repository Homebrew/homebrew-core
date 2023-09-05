class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://launchpad.net/juju/3.2/3.2.2/+download/juju-core_3.2.2.tar.gz"
  sha256 "d6a34b5c8cb60e1e1b7444c5afdff58d5746217f1f6b9b26b784f24187bb56ed"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3083e5b7d33bd9f9929468649b333749de388971a1285d875ab539ef6eb1bfea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acfe580791c3e2f033c975705eaf5be139aa6fa9d8c6c4e891ecf51417edcc51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17397eacb927da81b9d49e79ae8586ff4af5e20fd2e369e5449eeaf36b6010d0"
    sha256 cellar: :any_skip_relocation, ventura:        "d09bc6b0f0cb57f0715c1add2c28428d2acd218b470972e01450534c94d39dd0"
    sha256 cellar: :any_skip_relocation, monterey:       "3535f38ef05cfb4eca98d8eca23ac34b5e840ace50c80cedb8eade352a0ff83b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d54967dbe9bb1564bc46ce6928806e76f7a022ca0c040f40eafb97b30150890b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29561c0fba57846640de463a2330e2c35da3a62aae514088922d4b79a713102f"
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
