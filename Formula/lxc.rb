class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-3.15.tar.gz"
  sha256 "e93cbdae3873d993e32d2d2b85ff51de9085ebd464631c83242442e97574c4e6"

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

    ln_s buildpath/"dist/src", buildpath/"src"
    system "go", "install", "-v", "github.com/lxc/lxd/lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
