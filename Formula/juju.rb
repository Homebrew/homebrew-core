class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.0/2.0.1/+download/juju-core_2.0.1.tar.gz"
  sha256 "af5d59f4b4508c3f81b15fe052fe377876f5de845885d6d41d054f4ac605b9e9"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "9687c6acaac4fc2429acd45bb9f8f6ebf3f5d8a60e8c410991d5193f7f9c64ad" => :sierra
    sha256 "3e1f5d7828b79b51f344f9bf33ab6d712dc02548d9fd7ad372b814ee04bd86ae" => :el_capitan
    sha256 "c377b6ca32e938b9e309bc39fc9fe466a4bf7a42a85c5b8e89238612af820de7" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju-2.0"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
