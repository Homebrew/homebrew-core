class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://launchpad.net/juju/3.5/3.5.0/+download/juju-core_3.5.0.tar.gz"
  sha256 "ff8742c865a3671b843f0238196e7687dc7ea2cf79e00cfebd15d2da2fd0031c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73ba8971ef6ac2d12940d98b086c9f9a1093d8d1dc8e231a0c69a373e9864522"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cfda45a183319920c245ad55b8c59207b77988460e597a3d6284e8b0451c549"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d24d85810d874910d6330fcc4b94bc9d60ffc4d3654eb888c29bb1f9c8118469"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc37a1a8d01f7d01feec7bf797040417b454fa6e58906cf5d0e886c36d5bccb3"
    sha256 cellar: :any_skip_relocation, ventura:        "79c05961f6ce3e3933007ece114b4064ebcf065ce22968690ff462a2c18bd36f"
    sha256 cellar: :any_skip_relocation, monterey:       "2d79fbcc771071935678f7159ed186f6e357975b8c79193413a35cd431ec5785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87ae4441c41dd62ac4e7ea5e5b988bfb0d8db50bafdfb5bbd969b2e43c360a0c"
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
