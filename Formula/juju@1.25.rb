class JujuAT125 < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju-core/1.25/1.25.12/+download/juju-core_1.25.12.tar.gz"
  sha256 "083eca33d9b0484593449fcc5eed7f2a930f472f6ee82bce1e5ae5235fdc59c8"

  bottle do
    cellar :any_skip_relocation
    sha256 "49a435ad1108af78c1345a3dd745889b2e89a7069880d2cca63c8feafce6df70" => :sierra
    sha256 "64b846038d5e0991454553b387edfb3424347e082597e39b8a0374d5b255f728" => :el_capitan
    sha256 "95713c59b55548e2093849d566c3405edab780b00934b6a2bf056a9c4515cbba" => :yosemite
  end

  keg_only :versioned_formula

  depends_on "go" => :build

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
