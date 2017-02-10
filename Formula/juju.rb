class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.0/2.0.1/+download/juju-core_2.0.1.tar.gz"
  sha256 "af5d59f4b4508c3f81b15fe052fe377876f5de845885d6d41d054f4ac605b9e9"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "d5890a2590c920de2dea8a2b77cb3f30ef08d43cf8ec1da321f07313aa4c243c" => :sierra
    sha256 "4065e9a420208a46e773475697aae9393c5202262d3fd822b3154794566c1eae" => :el_capitan
    sha256 "0e0146d17f763dcee939d1cf02abefe1b6e1699d69e192e3c5c369ccd8acebdd" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju-2.0"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
