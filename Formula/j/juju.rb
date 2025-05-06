class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://launchpad.net/juju/3.6/3.6.5/+download/juju-core_3.6.5.tar.gz"
  sha256 "7e2eec738d7b8114e76d889d3f3f815fe4da4f95be73015ff524d9b5b2e9a72f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6fc9077bb6dd002473731d0cdb04996402fea9399a71d21f293ec3638dca045"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4404abc60c50ff07949e41329289701d0f35a89bc81f51d7f61d98d4824ce05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eafebce6b2a34de189beedf0bca7e0534647ee74e5d138e06353c3462f452209"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf4441427c2948c8d015b8fe321a5f12e88d54815eb870d916468a45c30384a2"
    sha256 cellar: :any_skip_relocation, ventura:       "6893e3f3fb4a89dd29967ff0a3cf317b5390813ba2e35d73df6da632c1788788"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e8dd1c48a3846ba95477f444e58e5a7465b0574fa112fd5d397a67dd664a1c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a91fb9eec0c17c8ff0c9112a0920d5831e3a63bd620415c443c659a26405d35"
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
