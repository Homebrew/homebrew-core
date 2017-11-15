class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-2.20.tar.gz"
  sha256 "0b715c65787d256213cf7e1576f502383bf267fc4d06476fcce016ef3df89cac"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb089ae980617ccb649a0ef7a547a4ce861b9b73a657963422555d3dc6e8dff1" => :high_sierra
    sha256 "cee99a69a28808ac3232aea01741f9272bdfa64c4aba3ac4becd36c18a9bb445" => :sierra
    sha256 "ad59c2ead16ab27cd9b305979fb88d9f7a2adae904f9828c02de3de50dce0a87" => :el_capitan
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
