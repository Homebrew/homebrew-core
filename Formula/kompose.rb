class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes/kompose/archive/v1.1.0.tar.gz"
  sha256 "912c6f1e1e609372e355237604cb8915d7b8b47147a3230c35ac5d9c2615eef3"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d1f927f25eaea188d4d72e01b2ac4114a9f27777b00f8be429fff3ee32037c2" => :sierra
    sha256 "1053cb76c50c63737f83c81e499f0a89c20aa01d20e32a13e9aa1af021e9f603" => :el_capitan
    sha256 "1c09acd079b72b6af858ae8ce3bc3097161a04e2c2cc62decf8d9b2aca1d2e55" => :yosemite
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
