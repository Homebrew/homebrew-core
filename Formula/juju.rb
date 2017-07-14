class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.2/2.2.2/+download/juju-core_2.2.2.tar.gz"
  sha256 "b415a4aaee6cba9ca8c0f550ba37d79c86e1ed82fb2f1f6be20e99ce96de47ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2b7760b4e942f0d9f38ef1f8d64e27b072e17c6625d0276a5c24d039c7c8621" => :sierra
    sha256 "14dd9d61c9f91ac7447016a51d0a88186031ebb4416f97ebb7ab6be101b3f5bc" => :el_capitan
    sha256 "da7e07748c9dceff0eed781f65723e264034ae4776271abf6a92997ad48eb25f" => :yosemite
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
