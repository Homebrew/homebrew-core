class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.6/2.6.6/+download/juju-core_2.6.6.tar.gz"
  sha256 "1faaeb561609689b9f5c34d0ef3ed4de1dc595a56dee38a5707c2ad63a888061"

  bottle do
    cellar :any_skip_relocation
    sha256 "a21ad6d5481c55f9b3d276882118735807f63f363534bdcfb0d49f11c29a9659" => :mojave
    sha256 "9dc5acf1097e94c691954ef3a737685ddf2341745592d6e6b242be4518dfc513" => :high_sierra
    sha256 "654fa4d4591d41c9318ff0a8c0fd084d3e73031a6f95e936b0c65aac6cad704c" => :sierra
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
