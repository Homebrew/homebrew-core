class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://launchpad.net/juju/3.1/3.1.2/+download/juju-core_3.1.2.tar.gz"
  sha256 "14970a2b1fb5099a72786dda183a3a03b9b798875e7c49df9060e35d31d6e7b2"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "256c97d382e1727a548cfff3181abeddde011166be653368b6be94c5936a133e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96878067b70952cf63696e559a13d4d739ba213b3bde5ed13eaa0758c91d0197"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35701ad59cbf27075a4c3ed017fb2468924a8b141ae9dd09e76f7b5f6f18b114"
    sha256 cellar: :any_skip_relocation, ventura:        "18af8fe9f68359314f926338ed9cef444caeb3982f0849f064064290cff65b91"
    sha256 cellar: :any_skip_relocation, monterey:       "17d5d200edfb9d2f063374b240ce3430e0570a5c19a3278d6453d2c61364418b"
    sha256 cellar: :any_skip_relocation, big_sur:        "560aa4fd5714dde822a8cd654eeafc592b417b514b02a9395d6e48086675e917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93ddb005bda3a2603d15b330b850f975e113e7ffa8634b7a976f4bce2a51e355"
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
