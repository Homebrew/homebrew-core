class JujuAT125 < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju-core/1.25/1.25.10/+download/juju-core_1.25.10.tar.gz"
  sha256 "8d5e6eee6a3adc9d6c240ef6a5806653644e30dc5b0b9825046a242b07944927"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0ad71fc333f02bbcda831576e73571885947e5289206d748353f474172c7bfe" => :sierra
    sha256 "cf2011da3e6f7fbbb73627b6f8737bfaf333af26131bb25f29c85f7419ec687f" => :el_capitan
    sha256 "71e3b915b5452125889e03be19dd6fad09cb244cc30c235f1d36841ea984788a" => :yosemite
  end

  keg_only :versioned_formula

  depends_on "go" => :build

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
