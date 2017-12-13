class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.3/2.3.1/+download/juju-core_2.3.1.tar.gz"
  sha256 "d494632ab37911e525421c8f115f54e8af95df3a2d3a58bfaf7d3f0838bad12e"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1a0e05a2861b65678d3db2870d778006cf7a0641e98f982c923527f47b5955f" => :high_sierra
    sha256 "03ee2c17ef4755274fcdaf90e6602c43f5e4b159ad8be0294a2fbb09bc87427e" => :sierra
    sha256 "00cbaa08071ec7fa472888446335973c74bffe893e7f275952d47d89745d3656" => :el_capitan
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
