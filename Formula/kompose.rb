class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes/kompose/archive/v1.10.0.tar.gz"
  sha256 "e07e41f9956bcc393e6417c353ee91199d6c860fed5ab8b48248358be0ab4c9b"

  bottle do
    cellar :any_skip_relocation
    sha256 "af7c8761fe20aa2b75fb7a1c2bcaf73d878abf8c3c738a2343766a286c39976a" => :high_sierra
    sha256 "9ef292b990038efb4304c0d9bb1771588c41b3e2c38856843eeca2a71ff23b82" => :sierra
    sha256 "7a3614a77bd45281622276fef57ae1641bb46b35162e152c63f1efbc6ff67120" => :el_capitan
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
