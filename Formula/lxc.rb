class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-3.4.tar.gz"
  sha256 "b3e8cdae1164928480b6221b87e7dd02ba32f8427efd442e5ffb81d493510d4f"

  bottle do
    cellar :any_skip_relocation
    sha256 "1551762d624891d174fa7261b4427154583d5cdb70f9ee63545abf2d25b25c39" => :high_sierra
    sha256 "00c6c492cd9f99c19deeeafb0fbce62e69f8103c675f16890b8684371e8e3e5a" => :sierra
    sha256 "c00f87d8f8696e95f67743e8ae0e22a78004e02b7f76bafd817325e5fa4f356a" => :el_capitan
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
