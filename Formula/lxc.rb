class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.7.tar.gz"
  sha256 "011745a66e971d95ada088dc42a9154028393de86871ea3ef4ff91a2976525ed"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "673fac6697fbe83b78af2b53aa58edd637c9596ec427ae35de74e066917beb0e" => :catalina
    sha256 "f8a6b5f03f2411adc8f797192bc679da188924e79ebd24a38c0a0774254bc6ba" => :mojave
    sha256 "04b3848e26f87ca637658c7e937b3d3ec95dc80c80511565d30625c1a25dd858" => :high_sierra
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
