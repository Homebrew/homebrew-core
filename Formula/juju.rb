class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.1/2.1.2/+download/juju-core_2.1.2.tar.gz"
  sha256 "fba57c0913f77b89f0dc2c73a7c70ebac5263dfb3a014c4f40551beae0a6fd21"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e866ec2f07f27e5d825090845f526007756d554352f0da253fad52dca972594" => :sierra
    sha256 "c662fb201b9e4318f057ddddb4ada7f71df44220ae85970d648e90803540980d" => :el_capitan
    sha256 "dfd7c089605e51d00d75ac1993389bf96ae8e7c56671fe223288a0f0ef984e8d" => :yosemite
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
