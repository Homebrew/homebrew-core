class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://launchpad.net/juju/3.6/3.6.6/+download/juju-core_3.6.6.tar.gz"
  sha256 "f84dc452c7344e50a6880abeb63001bd767c1230e853dcf736915282997a7405"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32166aff48993ce088c9cdd3119fde4c0ab9042ee06bfd64c8d28ed6e0af03f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00d3ae4adf537dcc6fa4baeeaa78c93c3cbc9b6a1f752c202c4a7a174696944c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4fd546d6d9b6c42a890083b86f2c40ccf594015ef306918d9e6a02a21428a9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "77e4b97b0bc2027a77e5aa9fb6cb9b069f5022954c5e420a7c34239bf70ece9c"
    sha256 cellar: :any_skip_relocation, ventura:       "ee878c126eb93e4e4a5a5f27531e1b7b77ed93ae9205273673ee27255dd2d9ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "218a12cd5f3c0f0d99596d41fe95fe267bfb002149574457e718de3008f48ecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e418d11d6f6dcd3e299366f54b3cf5e6f7ef6f2aab06bb041d78032f044e418b"
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
