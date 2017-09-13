class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes/kompose/archive/v1.1.0.tar.gz"
  sha256 "d0ef77fca5425ea988257d65b3690015f49248525ac7e67aeefa5bd16f9fbd52"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ae5762b511ce9f7aa78a591da9e707a5cec548439d2afe1a3078c613fc63093" => :sierra
    sha256 "c5cc2ef1c8473d53b1c2d62f979c97ace5cbe89b85cffb0d6a7d91a2bbf197ae" => :el_capitan
    sha256 "1166193d1df05482f78a975f15b5e05c4d8455686734db02e7ca8ac53cdf5837" => :yosemite
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
