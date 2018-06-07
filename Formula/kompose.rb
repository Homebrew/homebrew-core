class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes/kompose/archive/v1.14.0.tar.gz"
  sha256 "b92a9e9eb167894eca475cb2a511c2abaf2535294746a43ced278914aa2d65dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "d452678fa9675fec11311586a95c49e3ed9e19e16f21b5ce1ce174c3600fdf84" => :high_sierra
    sha256 "126697b0e5ceebe58bf9a1f62f8235e0db8456385c8ede7a9a456163f5f4315f" => :sierra
    sha256 "3c9d58a94760ba1f5e276a6e5fcb01b1406f291fa9e8d62c4433d170883f3048" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/kubernetes"
    ln_s buildpath, buildpath/"src/github.com/kubernetes/kompose"
    system "make", "bin"
    bin.install "kompose"

    output = Utils.popen_read("#{bin}/kompose completion bash")
    (bash_completion/"kompose").write output

    output = Utils.popen_read("#{bin}/kompose completion zsh")
    (zsh_completion/"_kompose").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
