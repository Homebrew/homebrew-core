class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.ubuntu.com"
  url "https://launchpad.net/juju-core/1.25/1.25.5/+download/juju-core_1.25.5.tar.gz"
  sha256 "7667b5695f1117ca48f1b40c24daa60d0b747c8c1c02ff4b96f2f8954688eb90"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad7e0824a8180098a689e9087219acb14e37ff44fe7515d4cfb15e0c99182133" => :el_capitan
    sha256 "3be1849359e87e9dd1bc4a44d3efeb033b7a6308215bfc0c13b889f3bfaf90fb" => :yosemite
    sha256 "4961bebf88d7c5167e6df8da19d652fea3c3b87a7936d37d130bfcb80962e717" => :mavericks
  end

  devel do
    url "https://launchpad.net/juju-core/trunk/2.0-beta9/+download/juju-core_2.0-beta9.tar.gz"
    sha256 "0f201909de0c77be21097f7749a32c131606e86a4b5940484d2fe668c108c22b"
    version "2.0-beta9"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    if build.stable?
      bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju-core"
    else
      bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju2"
    end
  end

  test do
    system "#{bin}/juju", "version"
  end
end
