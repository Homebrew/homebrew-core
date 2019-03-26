class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.5/2.5.3/+download/juju-core_2.5.3.tar.gz"
  sha256 "95e3290e4f761377eeef27998565b8d582406be4cdbd4c3f23b3a73b48015b12"

  bottle do
    cellar :any_skip_relocation
    sha256 "d40f2fe0186cb11ca3a75ebb4a3a9511906516a99a0ada206a26cf4a9d4b4896" => :mojave
    sha256 "397b5cd6d0ebcace734e296d3453accf1050fdf6f20cc1e2436ac5d9d465ede3" => :high_sierra
    sha256 "a57b6b6c7cafe75eff5bc4d9a8548a1c4e5b8f4cc43663b0564c4c2cf74c60b4" => :sierra
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
