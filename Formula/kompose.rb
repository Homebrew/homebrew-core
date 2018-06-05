class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes/kompose/archive/v1.14.0.tar.gz"
  sha256 "b92a9e9eb167894eca475cb2a511c2abaf2535294746a43ced278914aa2d65dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa3368daae3ea18a12d78d785cacbec1d6c576ea55a3315eebd39ad32f7ce0b8" => :high_sierra
    sha256 "dbfa58fede1ada8624322bceffd903bf6e41b8ab1bfa1c66587e66e37859f552" => :sierra
    sha256 "5801f974f26687c7123af27792c2d2afe9098c6f2ed7513bcb3f4a142b8eb463" => :el_capitan
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
