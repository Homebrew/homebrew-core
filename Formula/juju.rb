class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.5/2.5.1/+download/juju-core_2.5.1.tar.gz"
  sha256 "71f1aa4561641ee2ab78410df6776ec2904bebb9bd8e35d653ae13a7365c7f17"

  bottle do
    cellar :any_skip_relocation
    sha256 "df77fd0c547d23cd81535cc78fd14a3b44a0e76cb1a7068baa0ac81f8147f337" => :mojave
    sha256 "37df6c231009814749bd0db6d62309d1404107f1507414cfa9172e58270cda3d" => :high_sierra
    sha256 "31d2730f88202df2e03eaee779db98f3e19cfab9faca59a9ae57797193bdd5db" => :sierra
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
