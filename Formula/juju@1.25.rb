class JujuAT125 < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju-core/1.25/1.25.10/+download/juju-core_1.25.10.tar.gz"
  sha256 "8d5e6eee6a3adc9d6c240ef6a5806653644e30dc5b0b9825046a242b07944927"

  bottle do
    cellar :any_skip_relocation
    sha256 "5081ad67ecb06c1456edfca77123087f045ee5c970fbebc44c6ad09aa280b403" => :sierra
    sha256 "df85b3a5a8d08847cad3c9a8d8f47c06f903ff99a93a5a8eb3a62d8e738e2925" => :el_capitan
    sha256 "5c10ace05fee8614693e0a326d923f060752aa115358fb13192b2d3f0227da6a" => :yosemite
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
