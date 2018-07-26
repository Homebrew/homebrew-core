class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.4/2.4.1/+download/juju-core_2.4.1.tar.gz"
  sha256 "1b3bca6f8826d6a3dec2dd69453897458eb5fc35b7495dc6ddccb9f0f6874a80"

  bottle do
    cellar :any_skip_relocation
    sha256 "9520ec79d23ae5533f06e7319f7bf8fe06607fb6cb37a0478e12534bfd6c0ea4" => :high_sierra
    sha256 "8b26effd0a3a2e144f1f92600895edd19ebef5188d347adc7882766150b8d390" => :sierra
    sha256 "230a2ca4517187d57f0be41c3894792f6976c01bb0b1863d5444b3c5cd2e6d18" => :el_capitan
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
