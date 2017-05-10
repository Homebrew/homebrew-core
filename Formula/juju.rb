class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.1/2.1.2/+download/juju-core_2.1.2.tar.gz"
  sha256 "fba57c0913f77b89f0dc2c73a7c70ebac5263dfb3a014c4f40551beae0a6fd21"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ba8b7123b658212722ec7eeeaadb4991be7d8b63462b157882b332f0172593c" => :sierra
    sha256 "aea9aa0eac9717f736d572e8e04a9033ec42f6fa35b6250463620351ee087bc5" => :el_capitan
    sha256 "1743192126888e868dd613919897a8d8d559e024a0cfaa45c0d4ff7b3af66b60" => :yosemite
  end

  devel do
    url "https://launchpad.net/juju/2.2/2.2-beta3/+download/juju-core_2.2-beta3.tar.gz"
    sha256 "0d041cfa97224cf659444bfe42d16e63c8c4b5e0a3605162a43295b5b0ca0a86"
    version "2.2-beta3"
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
