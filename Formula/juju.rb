class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.1/2.1.0/+download/juju-core_2.1.0.tar.gz"
  sha256 "babfd21373f5866473dbd126aad460d17a71f972edaaa17eab0e6c239e5d2bd5"

  bottle do
    cellar :any_skip_relocation
    sha256 "079d70b168b3269648459958271ffcdf75823d81d0ea5c6f68c143a2f54df36d" => :sierra
    sha256 "5cb9110b133c45925bc86e2d962a760af67f065439c0ab32fc2efc18c3f1ab35" => :el_capitan
    sha256 "9beb96271da0a17929a7af8dba29af789c31ab022aae07eb6444192c4255b6df" => :yosemite
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
