class Charm < Formula
  desc "Tool for managing Juju Charms"
  homepage "https://github.com/juju/charmstore-client"
  url "https://github.com/juju/charmstore-client/releases/download/2.1.1/charm_2.1.1.orig.tar.gz"
  sha256 "bddf10c43eb0fa85da575d39d46f2041b2396c63351cce2cf8e2d6c271c7cc47"

  bottle do
    cellar :any_skip_relocation
    sha256 "4fe4cad12684442b2fa26cc2a5a3258a359b1e5a72fe9c9d6532fddb4f1e0bbc" => :el_capitan
    sha256 "fb69f3d68c12c81a242e6e8e89d50cf50269547ddd83a1c072dcc2dae56703a3" => :yosemite
    sha256 "fb0efbe87f759e3a014feb49067590a3c8fd4b002bf41bdaf2547da8a06f7671" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/charmstore-client/cmd/charm"
    bin.install "charm"
  end

  test do
    system "#{bin}/charm"
  end
end
