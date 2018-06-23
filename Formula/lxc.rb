class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-3.2.tar.gz"
  sha256 "6a388e1e5ad26adf32fbe1abb2f6e35a3307fa8c48e924ee0ed802e246c63da1"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f23a72a177465d6012f20e41dcca1eeae410c384f52a86a3316b2048ee1708d" => :high_sierra
    sha256 "85e0adcff900d03eb32ed9dcd489485652a944cf4a0bd0349666762700efccef" => :sierra
    sha256 "a182cac73d325d41803dc2ec9b130f19b894f1e051d40972aae6dfd966522482" => :el_capitan
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
