class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-3.16.tar.gz"
  sha256 "8fc9ba8b7eaa992d5747fd88740fb6933dca9e17e9ec4fe9d038eefc7ead6293"

  bottle do
    cellar :any_skip_relocation
    sha256 "f776d5f07134e9c623e16db47592fe7f36532a7cc12a7f2447aa595cd42c70a2" => :mojave
    sha256 "fc1751f60a9207bc60368ba8fee4b117a4be5d7611c74f6141ceeaa3946ba5d6" => :high_sierra
    sha256 "c8a6dc82461b93bae8f31697fc97d6276efa367722513bf90d05532a59a05074" => :sierra
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
