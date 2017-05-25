class Juju2 < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.0/2.0-rc1/+download/juju-core_2.0-rc1.tar.gz"
  sha256 "bef47f4d4e929a71c0934a782043fecc409a76ca4e73fbe3406415226077f745"

  depends_on "go" => :build
  conflicts_with "juju", because: "juju and juju2 cannot be installed simultaneously, and juju environments aren't compatible with juju2"

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
