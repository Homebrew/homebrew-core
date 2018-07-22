class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes/kompose/archive/v1.15.0.tar.gz"
  sha256 "b9a4cce6533d9b358f42e4d2e420aa9ebffb3f75cb4985a1c32079ea176a8eee"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee1a1afb895190147b4cf5ab1ae770833454780bc147c63e7be1013515b71b61" => :high_sierra
    sha256 "5ca9c20425f482f2a8c139df7279f3d914585444af98fb5aecf36a373f8589dc" => :sierra
    sha256 "1e3fb882eea685db4ef0c5dabacf315706018558529bbd64d3da4fe8d576cbf5" => :el_capitan
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
