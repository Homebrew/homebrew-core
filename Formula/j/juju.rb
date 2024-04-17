class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://launchpad.net/juju/3.4/3.4.2/+download/juju-core_3.4.2.tar.gz"
  sha256 "7ac8e2fdb0e9879193656b04971c39539ba65437334e6819366b5dc6caebf432"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc65d2974cc38b69a6045693f25ee4e99e3cce848b3d4f8becd0d842d8f2c5bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f56be38372e9706a32b40536993e195977896db989bcbab164a7282f66a724c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9202495932bf083340df4fd6f9ef91a04611e3bdc6d68705c5eb4fa1fd0af68"
    sha256 cellar: :any_skip_relocation, sonoma:         "19883fd21c12009f78f09a544ce2fbc46fa7fce6693c284319f96e6d60953312"
    sha256 cellar: :any_skip_relocation, ventura:        "83e359f67b80780d8737c88f12142c97689fcebfc0a381a4be3d8c05e9adeb1f"
    sha256 cellar: :any_skip_relocation, monterey:       "0a04a6b34ccc4f7f10c629be882f1ef08550e15de2c2a5d35b3dcc353ab3e046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c0cdc844e30c63fbbbba0a33f4dab79d133fb3585c80753d06380bce63e9581"
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
