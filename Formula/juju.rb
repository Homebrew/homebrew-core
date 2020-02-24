class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.7/2.7.2/+download/juju-core_2.7.2.tar.gz"
  sha256 "32cd758c7fbee1fa39e692f41ebec92849c05e48e62c1233c57f470998f29ccd"

  bottle do
    cellar :any_skip_relocation
    sha256 "f88c9151d62b56b8059b7f87b6368ed6c8c2032676c32214edf7315d4fb5279a" => :catalina
    sha256 "57ff460ef6f1dd58baeb6edc6d31fa604a3b428a221cac5bc3cea200c10c55bf" => :mojave
    sha256 "50a1f8f7674f2b44ef15170a0b1cd20740d5912321d0a93d3f4ed3a3a30190dc" => :high_sierra
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
