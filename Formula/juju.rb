class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.6/2.6.1/+download/juju-core_2.6.1.tar.gz"
  sha256 "68662d8ce1cbb04e55ac5ad55f25a1797b02f66b0637d6f2c6d9e58b76390b76"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c6c4d96f2ad7366483fb6eaecb67b4b29f978ef8c1f431a7d8c60d645e41e8e" => :mojave
    sha256 "35754f55eca726e5ba9d11852f44ba4bd1db0729bb4c2396c63d00c80e88eb6b" => :high_sierra
    sha256 "06bce4f71a62ef4a1ac68eb445a9895427d521811462ddc82cf7137447b13b01" => :sierra
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
