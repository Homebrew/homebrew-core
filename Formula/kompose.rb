class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes-incubator/kompose/archive/v0.6.0.tar.gz"
  sha256 "4e42dd2d247ab88382cc29ca9e180cf29e809f8112f533b5a2520c0adb547cdb"

  bottle do
    cellar :any_skip_relocation
    sha256 "027dec38cbbf379b2016e1d67f7c8d0148ae085d7d8afeb129731af732809428" => :sierra
    sha256 "679a1831d1b6cd97044934d820313e9625fe4ba2405a6374b6e6aef5fa41f316" => :el_capitan
    sha256 "0518e8891cfe2d67b3e7ecb8ac4909fa883d24cbe2c7e163f837c1040531fd05" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/kubernetes-incubator"
    ln_s buildpath, buildpath/"src/github.com/kubernetes-incubator/kompose"
    system "make", "bin"
    bin.install "kompose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
