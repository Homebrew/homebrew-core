class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes/kompose/archive/v1.5.0.tar.gz"
  sha256 "a55cbf0b0359b56a1ca6444d4a0ce7e73e0d89766a6bd75e8ed29af3cf317bd2"

  bottle do
    cellar :any_skip_relocation
    sha256 "91b9967f374b0e85db39695360513a2415b3ef42e1f93e6dcc6986211130720c" => :high_sierra
    sha256 "033e2dee09431f533c7977dd5015fe48ca3e9bc4c20675443b5bd4310c4b07ce" => :sierra
    sha256 "8e1fba2c69eb8ebd05fba72992c30bbf213421f20ab79c84300dae25ec81c60c" => :el_capitan
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
