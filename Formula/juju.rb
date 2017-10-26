class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.2/2.2.6/+download/juju-core_2.2.6.tar.gz"
  sha256 "cf44be0807c3279ebdbecede74bab40ef6714df660cb1cadae61d89a9b22c202"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee37c70eda2d00f624e7db97f2008a5f9276409a50506f231015eb06b6206525" => :high_sierra
    sha256 "aa57fc5ca264acc9d271e8659de015b0b753534ecfce0f88221583ec6d27399c" => :sierra
    sha256 "13d751f7364ce04d42f26fd073d37a3dd045086ed7f8002b612fa7a6ad5fa76c" => :el_capitan
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
