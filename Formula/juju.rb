class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.5/2.5.3/+download/juju-core_2.5.3.tar.gz"
  sha256 "95e3290e4f761377eeef27998565b8d582406be4cdbd4c3f23b3a73b48015b12"

  bottle do
    cellar :any_skip_relocation
    sha256 "2bef0dba1f1f5ce2b4b06a5a39d0ece18b4050ee470e542e8c171555e80c212d" => :mojave
    sha256 "31f57179868a2e00cc8af4fcd984f59fa9abbb88f94828280df4adf1a75916d5" => :high_sierra
    sha256 "27f867aac3215ccdac6e908625454e26c22896e0f161ab3744339b25e43385ec" => :sierra
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
