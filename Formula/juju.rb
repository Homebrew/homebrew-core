class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.4/2.4.7/+download/juju-core_2.4.7.tar.gz"
  sha256 "0b4cc36d38c19592a605c90c3df503e4c2fcb9dc8bf0b91cc87c396d82e40d82"

  bottle do
    cellar :any_skip_relocation
    sha256 "a68549e727a17b3b0e2e4338399ea4028a9efca9372bad5f7bfc08a5d11b44e7" => :mojave
    sha256 "6533234945cf9e90cbf4cde8a86b33c6572275914fe27a79861be6b2481f276d" => :high_sierra
    sha256 "d04082268db7df0af5622599e0cb71030f4e2e9059a241b8f0230bd066febc15" => :sierra
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
