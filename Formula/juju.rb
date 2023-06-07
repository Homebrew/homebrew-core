class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://launchpad.net/juju/3.2/3.2.0/+download/juju-core_3.2.0.tar.gz"
  sha256 "cd761ff63ff46f96b51ff94ec0b6871c519b242fb5966b5393a3a417386162f8"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97b148247322f5ba4f109f109ebb9cfe597c72d82b2463f7feac12990a5e2b7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd9862ca1ca90fb02c1300a09168946d33398cbabeff87cc476e312b239293a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30f2e76df904b15b66fd5fac7b00c99d3086107ceacfada159c3e2870d9d66d0"
    sha256 cellar: :any_skip_relocation, ventura:        "70b11b1a58d44fb9addf67bf6e22dc8689c7a3b40816d2983e096b8840e5d819"
    sha256 cellar: :any_skip_relocation, monterey:       "ced4599bcf5e6751771f319275e434838114875fd9d78fc0f35ac8fa30d1adc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "1557b7cfdc303123f9c10e0b867d13cd721296e10318c08bf36b6d3a2f966812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12d7e4dfa90d84e857309a9b5dcd99806ef7e66161ae84310c45c52b430037e1"
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
