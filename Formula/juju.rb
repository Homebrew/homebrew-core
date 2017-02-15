class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.0/2.0.3/+download/juju-core_2.0.3.tar.gz"
  sha256 "b37e78b91c5d96ddd28044b645f4fe7144f7c44e55ddc2dfea2ad134101a4ed0"

  bottle do
    cellar :any_skip_relocation
    sha256 "079d70b168b3269648459958271ffcdf75823d81d0ea5c6f68c143a2f54df36d" => :sierra
    sha256 "5cb9110b133c45925bc86e2d962a760af67f065439c0ab32fc2efc18c3f1ab35" => :el_capitan
    sha256 "9beb96271da0a17929a7af8dba29af789c31ab022aae07eb6444192c4255b6df" => :yosemite
  end

  devel do
    url "https://launchpad.net/juju/2.1/2.1-rc1/+download/juju-core_2.1-rc1.tar.gz"
    sha256 "dde7058b904d167c671e68a6915f6448bdcb04f2102923e136e28dac15c2e229"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    if build.stable?
      bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju-2.0"
    else
      bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju"
    end
  end

  test do
    system "#{bin}/juju", "version"
  end
end
