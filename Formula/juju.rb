class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.4/2.4.7/+download/juju-core_2.4.7.tar.gz"
  sha256 "0b4cc36d38c19592a605c90c3df503e4c2fcb9dc8bf0b91cc87c396d82e40d82"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b4f4f73bbfc64b5037f829592b4bd7dc93682973809f4553170ea7ae03be47b" => :mojave
    sha256 "fdef9af3b15299468b14171665095bdc63f2f1aad3471554b975bc5198a50e7e" => :high_sierra
    sha256 "f5ea70c523419704878f34174a09525be3bb9ededf334b86c1bcc2635560896c" => :sierra
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
