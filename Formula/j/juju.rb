class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://launchpad.net/juju/3.6/3.6.4/+download/juju-core_3.6.4.tar.gz"
  sha256 "816dcaab44fc878c4010273941ff2b03734c769aba7016eb81b3726676672794"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "274d1d03dab1dd8b640934f8e10cf1694409551ff4ce60b2a2c0ab2b9103cc4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "963548a37300cb533055dd38e2d3b9e6318253d1a04f81225d7cf099cfce8fd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93fdc3e012711a5c567507c9727168dcbc7a4c8bf1cc740e6dd6fbb79a6d942f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc66fca2f7d37de0df9e41db117481ad6a53efbbecfafd67f6179b7fafc77521"
    sha256 cellar: :any_skip_relocation, ventura:       "8baf5d3b899bab3542248b87dbbd344881805faddbe31002a02a81b16175927f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7916642ff26d8ec38b13028301b704d657df791c2519efbd2c0cdef5d8b5609b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a0b382ca13ff9d2c9c830c3295dd841b427793b30cdaa84d50cec5af8dc0d5d"
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
