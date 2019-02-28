class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/v1.17.0.tar.gz"
  sha256 "79835d7ece8fea423b3c681c14d689d376c728840f5a80b54844d8aa2a5040b3"

  bottle do
    cellar :any_skip_relocation
    sha256 "1281f09c192ce5ba3641211be0cebc04ba6fcf927dff08956c336054c2e9f813" => :mojave
    sha256 "3b4a37a6fff8b68446bd44b737dd041820f60f7ae9067118fcc07cf5ed951983" => :high_sierra
    sha256 "fb1ec8cc46faaaf29b3d1241971d86202e12766ca7a9aaf83f675b70fd49bfbf" => :sierra
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
