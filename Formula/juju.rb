class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.7/2.7.0/+download/juju-core_2.7.0.tar.gz"
  sha256 "eb3bbec34a99923c4b2fb0c89f43dda78f8ab03fbb42ef725fdc1311eded7826"

  bottle do
    cellar :any_skip_relocation
    sha256 "f53bc53815c4cfd697367e007c465fe0bd39b5a70cd12688cc54f594daffeeaf" => :catalina
    sha256 "f904882a0c72ffad08bb0e4b5c97b744c82ee364027b8d99168ca9e3659dc869" => :mojave
    sha256 "7f26bb043ef8cb69589f1746c364cf57499d8c354a0f6c8ce083083dab18eb0b" => :high_sierra
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
