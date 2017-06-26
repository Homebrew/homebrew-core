class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.2/2.2.1/+download/juju-core_2.2.1.tar.gz"
  sha256 "ae08d1c6e6acf88a3a5a9d85e5131068b17bd761ab4bd41d6d206dd5e14470b8"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a15af9d90785207a337a0add8cdc8681c6ab90488480f670d4c41668868b588" => :sierra
    sha256 "0f0b1059fe349600ff386d7863b8ff811d7510cbb32f64426d83ce8ba37e3136" => :el_capitan
    sha256 "0df37f1dd350d8708c1925c119727d18ce239b9c2a95529837080c19d633188b" => :yosemite
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
