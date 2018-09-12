class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-3.5.tar.gz"
  sha256 "2bf5221c49d5b7dfdde3c8a679dac55564cbbff0f2b0877b5e1fde51ecc61f1c"

  bottle do
    root_url "https://homebrew.bintray.com/bottles"
    cellar :any_skip_relocation
    sha256 "b86063e97a278e8bbd6e6e170dc9883c145fdffdefa550d47ba460b2ce546b16" => :mojave
    sha256 "81e41e4aef9a571517ed086e97bfcaf82de5340a527ae42a1ed0f44657b5e5a2" => :high_sierra
    sha256 "1ce01ea1feacdcd27039d75db593ad80b15cfbfa4bda682c34235c2550618cb3" => :sierra
    sha256 "c268964365567d83ef74757d42bf6c5f43b60dcbbb7060a903d8c0d1c7a4243f" => :el_capitan
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
