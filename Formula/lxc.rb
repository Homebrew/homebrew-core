class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-2.17.tar.gz"
  sha256 "3544a8f7119d1718d136cdae2ce9c74d4544ad9ef55517dc234cc69538b0c329"

  bottle do
    cellar :any_skip_relocation
    sha256 "c03cbe49154a1d9ef6331784e2b30de2483de3ffa6be69c4674732e5bb9125cc" => :sierra
    sha256 "b0e4830b4745df558bfb61b5209e4694dedb8a3cebdfd247ba0cb92028f93438" => :el_capitan
    sha256 "1352d34e66cd74dda4934b0e92c75d8a51da0937ad754de0ef0c98f5a898c374" => :yosemite
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
