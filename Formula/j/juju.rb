class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://launchpad.net/juju/3.6/3.6.2/+download/juju-core_3.6.2.tar.gz"
  sha256 "d4fe880b8547e416904e337a4b9737617212f12c089149a5e000d4304ada552f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec006d5e132b72f705e70ba37372d174eabb0d476208bb6612c7d486ac3cc544"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bbbdfd6d9c0fd35ca40d3f2f2d6ce1794aa26cd956bff02fb9971a2d45bb282"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "914126f4a4c034a2bef01099c10b89d79d10154269d6953fc5dbfcc6360b26a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac07a6009dbb4a024cf10b33c7859bdc2c2d1a879b617f3f5ed2e3abe60086ea"
    sha256 cellar: :any_skip_relocation, ventura:       "44d7386053135bb1ae4e308d2f11b3f69e278230c79ab57e68fbce1a0d5a9527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fefd5a24583fb310c1da0c5b5beac987a962ebc7f00536edaa12fa8cba16534"
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
