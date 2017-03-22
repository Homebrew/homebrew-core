class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes-incubator/kompose/archive/v0.4.0.tar.gz"
  sha256 "a7aaf5a01d8563e3648d4155250ba96f964f1f0a1e682ea431c7a952b00ae8f4"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f9c9222f6bfa1971afbde27a1d79e64431caf5394cf5657065e30f272f21ef2" => :sierra
    sha256 "593a2b4a2bd8a077b8ad590c2c59f0a43145970782b7164a9a5fec1acb0bdfae" => :el_capitan
    sha256 "e69133d21c5b19fc9e0ef522d518e9ebbd3664bb1096ce583538d66f448e38ea" => :yosemite
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
