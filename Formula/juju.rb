class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.3/2.3.3/+download/juju-core_2.3.3.tar.gz"
  sha256 "98b13d76c34118da110d3bc50931de9b7aa69594ebf2cb18b37cb187a9ffc6dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "b58e53bb2941bcd2ebbdf55032ef4c56ae27c500342ea12b3e10e9db7cdde4ad" => :high_sierra
    sha256 "1cbf20e640607fb17563014850338153c943874a80f184bcb9a02918fe5bdb4d" => :sierra
    sha256 "54f805f0d63e5e06a0e44c33dfa28fcd985967f282addfb72a6c145a3e36ab37" => :el_capitan
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
