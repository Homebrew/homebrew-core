class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.6/2.6.2/+download/juju-core_2.6.2.tar.gz"
  sha256 "24d51baacdd208176defca747b664dba7479c4fb59e51373b0c6dddc4a9790cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "14bba10743ec91455b5b28713d2b133e9c661666b433ce3055074c961f821b0e" => :mojave
    sha256 "6ca25e1825803cbf04756f70522a098e4d9f8f1b9357ce8413afa2c96c36cb70" => :high_sierra
    sha256 "995db630a380d1017bb81852795bb09aab4afa71d8e3c3ee7767a4a13efc0d6a" => :sierra
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
