class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.2/2.2.3/+download/juju-core_2.2.3.tar.gz"
  sha256 "2423ec212ddb6157eb3ccdfdcb8e2fae6bc93a106941e06a5cd249f17ad50ec3"

  bottle do
    cellar :any_skip_relocation
    sha256 "11b4c4a575eaeb8ab0050665281295e1b609c458d7589ef7b43c417304ae596e" => :sierra
    sha256 "07001af4f07870a01804a57dd4f793c7eeac9f6f8ab58fedf4b2b63162443bed" => :el_capitan
    sha256 "80c741ef89d44429bce238691dbc97cfccf26a59a82d5dbc21fb21940837f6c2" => :yosemite
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
