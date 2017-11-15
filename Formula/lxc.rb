class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-2.20.tar.gz"
  sha256 "0b715c65787d256213cf7e1576f502383bf267fc4d06476fcce016ef3df89cac"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf11313104d88294125c9bfe8cd3092c5cd7a669c98d8f3e49d6bef962bbe9a2" => :high_sierra
    sha256 "f839fa32798aa787b122193a562a6d953594130d39f8adffdafec55a816a079f" => :sierra
    sha256 "5d26a40b776802ad9dc71c432bac08ea77752134d6843739101894cff9ba2a6f" => :el_capitan
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
