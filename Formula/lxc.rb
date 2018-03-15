class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-2.21.tar.gz"
  sha256 "649540bc9581ac07ebe88aa999284a33a7d9444dbf679f880c0eac4c087c1fad"

  bottle do
    cellar :any_skip_relocation
    sha256 "325f979603960d5035c7fa17f6149d436addea2f8570d481bc30883cb864c32b" => :high_sierra
    sha256 "04b78e8696cf811513245c5471f15f30fd6b166cb584a78ebc58ade999fbdff7" => :sierra
    sha256 "d5616ea2105fd7f76638b4fb19160cb3492ba54c2b34afeef783e9d281cfde28" => :el_capitan
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
