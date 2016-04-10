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
    sha256 "1d60879b570097a916246e1d844d48abdbb7075dba9b6c348ee2c9e561380c93" => :el_capitan
    sha256 "040c41bf2a5fee185235d3bb378e2778feb86b2f1b41d748c2ce31a589de8920" => :yosemite
    sha256 "4ba883f62e16e65e8162e14dc46ba384c885b487bfe8e4274ae80525d8cc5cda" => :mavericks
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
