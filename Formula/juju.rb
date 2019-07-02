class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.6/2.6.5/+download/juju-core_2.6.5.tar.gz"
  sha256 "2222b5cfec023d7f6dca1f3f4dd4aa78e8d626d8debbb1f721b723f5ed584482"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4ac757cc8c75a8b4b3aafc2c7048a04cd63a94095e8f4b76e40085e30e697ef" => :mojave
    sha256 "e25a6e030017137870e83a544cc6f54703b8ec39cf10e1c8df4d0556aa8533cb" => :high_sierra
    sha256 "40513511e05fb7097e035d7ee9f6b1332ad4e8dc2dbb8f69a70112ec6c26a11e" => :sierra
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
