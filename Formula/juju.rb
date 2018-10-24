class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.4/2.4.4/+download/juju-core_2.4.4.tar.gz"
  sha256 "6ecf15a0ab89d0e936040a111d1c80e2bc9a96a550af9d6080c873f5e0b2487b"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e9e333646235a7eaf15f535a0c3ef6e825a5b89630ea0ad43f5c59eeca497e3" => :mojave
    sha256 "3669058d6cbb80ef9129b2856ea3dacffb94d3989bd102e6ab0fc5d30bedff12" => :high_sierra
    sha256 "3df762f5e44ff1a83c7caf894aa9a9c0919e7134c8061151cb56477cecb6cde3" => :sierra
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
