class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.6.tar.gz"
  sha256 "3702f5eafba6dba2ab21c2119bc74e8b55514d697c1fac80343adeea94d72e04"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b6621fca0e98a55ddc7cabe60e23f96f6403fc74e5eb2a2251da34628a2a0a93" => :catalina
    sha256 "3c45607a783dff338828008a11460812f40782f25d9b7e30c3fe259279b10df8" => :mojave
    sha256 "b3ad252a016e1103e036113390631efc878362739f7ebee795de478d76a5736c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    ln_s buildpath/"_dist/src", buildpath/"src"
    system "go", "install", "-v", "github.com/lxc/lxd/lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
