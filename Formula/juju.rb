class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.6/2.6.3/+download/juju-core_2.6.3.tar.gz"
  sha256 "7a39c3126cd595607f18476af24c405bc6f4a28e84c290057b4574c3ac86fcbe"

  bottle do
    cellar :any_skip_relocation
    sha256 "06796cdc6a32054d9fcc7781b551de2c056f37fb201891a8767051083ac37ebc" => :mojave
    sha256 "83109a243fefc25ef49bb432b0ef7ea308496717ac488aa701d99318e67883a3" => :high_sierra
    sha256 "ab2198cf22442ce4977528be56f1387097310025311773cb9ba14d1ac3a1ed21" => :sierra
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
