class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes-incubator/kompose/archive/v0.2.0.tar.gz"
  sha256 "a6be3935ff666b75ad06f389a5c23184c3c83659ae25135ab7c2c3d37b22d92d"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9ff134a40769ed9d390a2571bc16c49940c7cef071bd54d80a97424524887df" => :sierra
    sha256 "c633227d1ded597d8285086c8b704826ca99e8af64027fd430b4916c7f8d2bdc" => :el_capitan
    sha256 "18147d01cdd51b9f33407e9f8bc42ecc7f6f70ca6bd75d36ce855b1d85d37d4f" => :yosemite
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
