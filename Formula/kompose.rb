class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes-incubator/kompose/archive/v0.7.0.tar.gz"
  sha256 "6b649e91494e57ffd6c6f1d6150072d4c5589d75568172a8f3a0d6cbd7322599"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a0d5319a877e3f090de17aa16d68b272ed429c686d85e54d92abe9117c2744f" => :sierra
    sha256 "e6a08e3bffaa6fc55cd908e0e0a815db234c2d974f3c81f386d8277c2bb6c581" => :el_capitan
    sha256 "a24475f05304ee7f357128bdef2c3e5dd5e70e99ede80148675ba8a91016873c" => :yosemite
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
