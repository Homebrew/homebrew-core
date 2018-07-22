class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.4/2.4.0/+download/juju-core_2.4.0.tar.gz"
  sha256 "363324c0505b33b827eb9be76c3f49a4ee146601ef72012941914ff196162b20"

  bottle do
    cellar :any_skip_relocation
    sha256 "16a63c432ce40df407ca92c96298aa5d24b6d5811d263ca7ea249f507b4f59fa" => :high_sierra
    sha256 "92fff546a8760dec8c5d51ee6d433248fd1ed00a20ba4f41160a1ce9d1ad0c90" => :sierra
    sha256 "40c89897763b0fbd1aa81085dbda31a73b73b3a48a522d03d2daf1c0bccb15df" => :el_capitan
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
