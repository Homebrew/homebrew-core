class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.4/2.4.4/+download/juju-core_2.4.4.tar.gz"
  sha256 "6ecf15a0ab89d0e936040a111d1c80e2bc9a96a550af9d6080c873f5e0b2487b"

  bottle do
    cellar :any_skip_relocation
    sha256 "61683f8a55806072b66113bdd17302bf854c1b2e1e45db102eb07cf756799849" => :mojave
    sha256 "0397c8aa29b8cae10164d6b778ecae6754822f82b03c0705ff0298b3f6150042" => :high_sierra
    sha256 "f887071b1fefe254aa36b661b7af348e301683218d99b450cf642c483328c6dc" => :sierra
    sha256 "824a39d82847d9e63d9b225293437f7e3e6a4d1003304d7b699fad46ed2ee296" => :el_capitan
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
