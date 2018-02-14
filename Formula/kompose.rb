class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes/kompose/archive/v1.9.0.tar.gz"
  sha256 "7238aa94869538bdbb07b503ded7acbc24dd9226d77556ea6687791e7d47fd63"

  bottle do
    cellar :any_skip_relocation
    sha256 "f51e6506e7ff68c148bdc61be86a30747fa6e58b7862dc3cd61e6315aaf76b17" => :high_sierra
    sha256 "738d15a9ac555e333cca506404bc28eddc311a16933289eb8ae26e311191a9a9" => :sierra
    sha256 "fc471fce6625b5ceb97450906551a2dba77fe3e3399e575d2a97445d8aeee361" => :el_capitan
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
