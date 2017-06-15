class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.2/2.2.0/+download/juju-core_2.2.0.tar.gz"
  sha256 "166019fae5b510144596ac32b5f2174597617533f6d9558d5633f9f1a88306a0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c7e0c35c9264ababf10d1286234ed3756e96d7dc69f549a1880bebc760f4384b" => :sierra
    sha256 "5dcee49167f905d08975b27f7d25b94fd5c88437889c0e7308bdb0a81217ce7a" => :el_capitan
    sha256 "e7f179d5d9ba60634bbd0bfa7ffd1f10bc004bec78c779834808f920c0383fc7" => :yosemite
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
