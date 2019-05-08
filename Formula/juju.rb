class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.5/2.5.4/+download/juju-core_2.5.4.tar.gz"
  sha256 "d5bc711df3753cee45c258cc7ce3ca9d4492f77d8d1db9fc073fbb93ad6f62f6"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba8afe300f829f9864d38b399f80d65c94f365dfe5731633e8bf178b435ebae8" => :mojave
    sha256 "16b772fa42a3b52e427e8f185c58c11d3dc843ff60f15f24ee30792ea0d791db" => :high_sierra
    sha256 "a77fc04d4c813f7665abe6a054c7ba721dc927caf9910f6f28ecadcfb21f62cf" => :sierra
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
