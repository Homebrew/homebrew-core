class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.7/2.7.0/+download/juju-core_2.7.0.tar.gz"
  sha256 "eb3bbec34a99923c4b2fb0c89f43dda78f8ab03fbb42ef725fdc1311eded7826"

  bottle do
    cellar :any_skip_relocation
    sha256 "1795260adad48825e7f1e1e1a660c00ab7e2510b45f17a8d4c9b96c8fe33f2fb" => :catalina
    sha256 "ac6cf31c6c13eadae1c4b284a7193df75c8e9b0b8d992fdb093172304b84ab84" => :mojave
    sha256 "0ebb00c224483f768f1255543bcf572186065ff3329bed30c6c34492f4029f39" => :high_sierra
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
