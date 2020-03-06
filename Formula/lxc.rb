class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-3.22.tar.gz"
  sha256 "1692cec36c836b101384830abc7753b1acdd46df0cbea5d5b41633cfa4eac0c8"

  bottle do
    cellar :any_skip_relocation
    sha256 "07ad21f46f7091bc753920f7f647b83a766e9ce85ef089acc8776a132e8ad2ad" => :catalina
    sha256 "81d60516c656d9f66fa6eae2600043f850a03ebcf8b4757d556a36c81c4a906a" => :mojave
    sha256 "d2c815d313413f0d472146d27fad5e210375132d56302ff7c233e5d28a0925fb" => :high_sierra
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
