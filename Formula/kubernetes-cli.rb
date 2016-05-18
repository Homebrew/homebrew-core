class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  head "https://github.com/kubernetes/kubernetes.git"

  stable do
    url "https://github.com/kubernetes/kubernetes/archive/v1.2.4.tar.gz"
    sha256 "20a3984f9c044f1a1da3088166b181f3c10380d3efd4bf3fbc64678fef279ced"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c2afb7e7b7fcc5f81d8b139c0bb6b6fc19a1269b8e0cf5fb5f956260554e00b3" => :el_capitan
    sha256 "dbbf24d98fdee97b0675c6be8233ba5795c60508e8a2d02c9d3d254fc08517c5" => :yosemite
    sha256 "f4178cff5b72929e176095cd4c734b3be6c77525028381da9793b02dcd474ccb" => :mavericks
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.3.0-alpha.4.tar.gz"
    sha256 "3cff9661b94c138149721e8f57411e89690afef97bcdb515092ca3acf8705900"
    version "1.3.0-alpha.4"
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
