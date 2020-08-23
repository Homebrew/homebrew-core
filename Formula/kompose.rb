class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/v1.21.0.tar.gz"
  sha256 "64bcb4705e8312c83faaefd8ff4399936e69413662344a683becc2c34d8679f6"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "49e2f40f406d9de4c53a4cdfe4c5e33f2725521dd6e37b42fbe27ee2e004ac89" => :catalina
    sha256 "90a31f44f8dfc99b19485f753c27150e693882f2e35f2f5baaadb7c0e367ebf9" => :mojave
    sha256 "753239b64a99b54c4e808d628b6ecb697a5f3f91b7c2211b0a666254472c8a14" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/kubernetes"
    ln_s buildpath, buildpath/"src/github.com/kubernetes/kompose"
    system "make", "bin"
    bin.install "kompose"

    output = Utils.safe_popen_read("#{bin}/kompose", "completion", "bash")
    (bash_completion/"kompose").write output

    output = Utils.safe_popen_read("#{bin}/kompose", "completion", "zsh")
    (zsh_completion/"_kompose").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
