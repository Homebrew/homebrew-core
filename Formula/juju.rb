class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.1/2.1.1/+download/juju-core_2.1.1.tar.gz"
  sha256 "3302c1915af4ab0ff4028b596d3db56329c7394a34ec688ace0203158ec51118"

  bottle do
    cellar :any_skip_relocation
    sha256 "475253c7f41647b18ee7819249aa724a86240d920d8dfc85fc7c5f0bfc9d7e0a" => :sierra
    sha256 "9e9dcece58175185fbb4d2b9f88280cc2cbfdd5dbb7f0ad1e5303f2f855c0dfa" => :el_capitan
    sha256 "3b53c7dc133f4ea026586fbb5b9375bd7f9dfb08d83891a229db57fd4be22ec6" => :yosemite
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
