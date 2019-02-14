class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.5/2.5.0/+download/juju-core_2.5.0.tar.gz"
  sha256 "68d2114b1bfb762acbc066314186307f2c16746e81eab57014ecbfda1238b345"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a615e22f3a0427ddc56d165f11f6b2ba417787da5cb7221d5090f88701a1573" => :mojave
    sha256 "a4a37c32fdad288c5da4775d8494ab76bcb63493aaadc200442ea8ccff052df5" => :high_sierra
    sha256 "496283321f242eaf26f27ae25e568bdf2d2b74be8a19e048623a54ef3fc764ab" => :sierra
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
