class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes-incubator/kompose/archive/v0.4.0.tar.gz"
  sha256 "a7aaf5a01d8563e3648d4155250ba96f964f1f0a1e682ea431c7a952b00ae8f4"

  bottle do
    cellar :any_skip_relocation
    sha256 "7095b953c0beea35557030d42c2a303de81c486d46e16dbbff46c1567d3fbb38" => :sierra
    sha256 "77fe3b92ea3936936b0ddc1c9f5fcad2f104e143032d7120675c8c83141047d1" => :el_capitan
    sha256 "ba83af454b99d71f10df3ef664c5e4ae0841769060124a5b2aab9df15e40b8b9" => :yosemite
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
