class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://launchpad.net/juju/3.6/3.6.8/+download/juju-core_3.6.8.tar.gz"
  sha256 "c11bb17d5bde7823a63e6354c785274c42008cfaf0e6abeb203b7ec89c83f890"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "main"

  # We check the Launchpad download page for Juju because the latest version
  # listed on the main project page isn't always a stable version.
  livecheck do
    url "https://launchpad.net/juju/+download"
    regex(/href=.*?juju-core[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b98c9f297f29e76112887dfd4eb4d978f409d89ca46dbcd4b7e1802bb92f098f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b567efd235b7b08295be11f2da98ccd539d962e15bba629203eb91f55f461f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1ee9eca10d09c293f9886689d122b152e953210218f305b40814ab6a15a9aed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b536102f62cc526b92e4c056d8e31310ec0dced2885c9f2a8652aa07210c53ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6409d90d7b3278931e81518243f72d669fcf30f0a2f41f555e0473e841da5bc"
    sha256 cellar: :any_skip_relocation, ventura:       "516fcf50b842a869b5f616654618d47c5c7414ddad5aeae5edfbd46511470283"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efcfb8010c34b2f3ab61b39a9ad193f3dc1f560a7da11ada08694c8b942d920a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0eae5af767a79d6aff0d4b76caafe13f87ea95375df93403d96ea611fc42a805"
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
