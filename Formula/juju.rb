class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.7/2.7.5/+download/juju-core_2.7.5.tar.gz"
  sha256 "096c2ea02f6262d85dfb1915d34b3be2f6832b224555f8d8e99631a4b9f785b8"

  bottle do
    cellar :any_skip_relocation
    sha256 "97f51bd0039f04f1d73ca1811209d7236f3c89e5f6d2be08f01093b78379d8a7" => :catalina
    sha256 "8aa5f3237a8b0013f7227be77728f69c7e3de94f275b740904dfe04855411521" => :mojave
    sha256 "95cf29b37006e8d52e10f9955ec42fee7726b4df771c981f333f47b76b832e7e" => :high_sierra
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
