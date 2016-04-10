class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  head "https://github.com/kubernetes/kubernetes.git"

  stable do
    url "https://github.com/kubernetes/kubernetes/archive/v1.2.2.tar.gz"
    sha256 "28337012d145a540e840a1da0d0271ca53a6e279c790ccc409a1b82e2f675b54"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "107a2b0702fb36f2f52520ce333b9d1187003f4c9d6ef45b8e43f4d713025ef9" => :el_capitan
    sha256 "ae002598f3b6887874402b2d791990fd99a1236539e5ce9aeee2b370e5fbe3d8" => :yosemite
    sha256 "d6032feca6988d3a1409c34763c545caba341503dcd093888b0a5b47c42c22c6" => :mavericks
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.3.0-alpha.1.tar.gz"
    sha256 "6297b75a01784195ce9b85a8c784b3cd593c06967b3e9f87d608edd77418b22b"
    version "1.3.0-alpha.1"
  end

  depends_on "go" => :build

  def install
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"

    system "make", "all", "WHAT=cmd/kubectl", "GOFLAGS=-v"

    dir = "_output/local/bin/darwin/#{arch}"
    bin.install "#{dir}/kubectl"
    bash_completion.install "contrib/completions/bash/kubectl"
  end

  test do
    assert_match /^kubectl controls the Kubernetes cluster manager./, shell_output("#{bin}/kubectl 2>&1", 0)
  end
end
