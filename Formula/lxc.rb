class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-3.1.tar.gz"
  sha256 "bcfe2661d97af0dcc0ac5de8407b6e24de8615e6b7881bd4bf8e9c59fefc673f"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2d966f4ef3d9948be1ddaedb09c262b66a73d76f607df2255a9fd978d46aee7" => :high_sierra
    sha256 "ac6f270b8febbe11b9ac6a50bb9666c37cffbb18a5f3e592526f44f33a931098" => :sierra
    sha256 "e202b72984a8d2a0ff76fbba1138ee652ca476a2dc04a5349ab7c7fbb4d7e262" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    ln_s buildpath/"dist/src", buildpath/"src"
    system "go", "install", "-v", "github.com/lxc/lxd/lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
