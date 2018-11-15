class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.4/2.4.6/+download/juju-core_2.4.6.tar.gz"
  sha256 "6021324c819354533160d0030f1d2e932ff8fc367c7773e514cde9ecdb9b4711"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ed52d9c4181a4ce242f89e050f2e2a659e1fe62ad88d7a6768341f235daa8e7" => :mojave
    sha256 "475735ea91e8632567b8baf0f507d92dfd41d6a0deb4a5c3c83a952e423b5dde" => :high_sierra
    sha256 "1ff7caf11f8cc80fc81e338f4c2049458a3769e876b4e45f61f13a9b4e33434e" => :sierra
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
