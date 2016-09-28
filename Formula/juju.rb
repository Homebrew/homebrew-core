class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju-core/1.25/1.25.6/+download/juju-core_1.25.6.tar.gz"
  sha256 "b826cbc4085fe3b3cf5413ef5dc20ece1fb69d36fa6c0dda711aeaaca19ff7fa"

  bottle do
    cellar :any_skip_relocation
    sha256 "38cdb304054dadf46258c6ca79a65520fdbd315b5f11f582e035aed0edf5bc42" => :sierra
    sha256 "75e0c0d140097fdbc279ed90bf94d5ce260cf73a942abbf2321653b6a3942cb6" => :el_capitan
    sha256 "1c6a2dc852a800c59576a85625b0df1796715dd6104e7daaf9a44efd99d0aff2" => :yosemite
    sha256 "76a5338a55ac6aaf7986a6870738422639dce42bb0b0f095e01a25f31ef5b6f8" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju-core"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
