class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.3/2.3.8/+download/juju-core_2.3.8.tar.gz"
  sha256 "e92bb93b47c9dcd9ab3afb7d3efde43ad244140c373ffec71c7140e54f0828ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "6fc18f158224fbb30ec1bcbbb3fe0a0cf526682b3a8c4ab32f8ebf0ec2ec2eac" => :high_sierra
    sha256 "027c2f130e33193f4200c454de81a6d8517fe62c97e6d216ca958e4101100f76" => :sierra
    sha256 "9228b79b6e9a82f141ab6e6983b17b6f9d436d10be12b5911854b4c51288f9ad" => :el_capitan
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
