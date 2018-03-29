class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.3/2.3.5/+download/juju-core_2.3.5.tar.gz"
  sha256 "2cda0d4487359497dc29c7eab3cd4241499c8b4ac152c22a09c14b4aab766496"

  bottle do
    cellar :any_skip_relocation
    sha256 "efeaa203d0dca65144f40af6f72315899731fc450e3a7475952a6ccda1187094" => :high_sierra
    sha256 "63ecad2f6ef8a7d1bb4c44b136e3e7593410bf1e825a037cdeade2040a5c23af" => :sierra
    sha256 "b0ebe42a179d31c7e24ea999e564f4523ac82601aee4c2e768c04b845b5250e6" => :el_capitan
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
