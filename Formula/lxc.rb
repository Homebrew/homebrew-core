class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.1.tar.gz"
  sha256 "3f5231fa4a26d06f386fe03dc8779c55fe9baec8be826e9f688354ce4f917f6b"

  bottle do
    cellar :any_skip_relocation
    sha256 "8805cd309588e7b29c7a1aa17277b7fdad31465a594c79894c737dc87496a0b9" => :catalina
    sha256 "fc3cb0e207464510a70eaac52ab8488b4611c47d48c56cf98a6e2f08f89aacab" => :mojave
    sha256 "0f565ceaff519ef75ca8a1fdcb91e8715089fed50758006ef4e932ed2b93fb3f" => :high_sierra
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
