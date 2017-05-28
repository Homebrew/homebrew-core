class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.1/2.1.3/+download/juju-core_2.1.3.tar.gz"
  sha256 "cc0436d1474d3d87d7d2193bab271d647640db2ce115f2fb9dd71b92b019d7d0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c7e0c35c9264ababf10d1286234ed3756e96d7dc69f549a1880bebc760f4384b" => :sierra
    sha256 "5dcee49167f905d08975b27f7d25b94fd5c88437889c0e7308bdb0a81217ce7a" => :el_capitan
    sha256 "e7f179d5d9ba60634bbd0bfa7ffd1f10bc004bec78c779834808f920c0383fc7" => :yosemite
  end

  devel do
    url "https://launchpad.net/juju/2.2/2.2-beta4/+download/juju-core_2.2-beta4.tar.gz"
    sha256 "592a0f1f47e3a42648d4647a08d159af9d68faf80974ab4171bd4bd22a2200eb"
    version "2.2-beta4"
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
