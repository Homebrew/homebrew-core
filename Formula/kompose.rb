class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes/kompose/archive/v1.0.0.tar.gz"
  sha256 "b9c9bfc9f25c67cf7d8d8b76467487255f9882fca563f8e9ef990f647cd2406e"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a0d5319a877e3f090de17aa16d68b272ed429c686d85e54d92abe9117c2744f" => :sierra
    sha256 "e6a08e3bffaa6fc55cd908e0e0a815db234c2d974f3c81f386d8277c2bb6c581" => :el_capitan
    sha256 "a24475f05304ee7f357128bdef2c3e5dd5e70e99ede80148675ba8a91016873c" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/kubernetes"
    ln_s buildpath, buildpath/"src/github.com/kubernetes/kompose"
    system "make", "bin"
    bin.install "kompose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
