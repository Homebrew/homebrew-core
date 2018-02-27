class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.3/2.3.4/+download/juju-core_2.3.4.tar.gz"
  sha256 "1b1057e9372a4cfc9689dcfb8ff88ee13dad953e0d82bbadfb9626e346c7592c"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed92d69d256a19ead50f139437f063e865008123b0c87d4be7b6fa3bbfc09fea" => :high_sierra
    sha256 "051b9e188b0e9bcda30364015ffd6bee5c03550e71600ff6b65f25fbbd7ecd23" => :sierra
    sha256 "4530a6f0b5a7c3d4242fadbcb9eebddfd29477eb219a066e943ab1173f4cc2e4" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
