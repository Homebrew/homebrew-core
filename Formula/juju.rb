class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju-core/1.25/1.25.6/+download/juju-core_1.25.6.tar.gz"
  sha256 "b826cbc4085fe3b3cf5413ef5dc20ece1fb69d36fa6c0dda711aeaaca19ff7fa"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad7e0824a8180098a689e9087219acb14e37ff44fe7515d4cfb15e0c99182133" => :el_capitan
    sha256 "3be1849359e87e9dd1bc4a44d3efeb033b7a6308215bfc0c13b889f3bfaf90fb" => :yosemite
    sha256 "4961bebf88d7c5167e6df8da19d652fea3c3b87a7936d37d130bfcb80962e717" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju-core"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
