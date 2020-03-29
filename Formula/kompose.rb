class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/v1.21.0.tar.gz"
  sha256 "64bcb4705e8312c83faaefd8ff4399936e69413662344a683becc2c34d8679f6"

  bottle do
    cellar :any_skip_relocation
    sha256 "e769a37febb0d4bf08901f266dfcd6cdaba0cce741a44727371e2b5191c59039" => :catalina
    sha256 "09c6779b612484a7320b5c47e2bcff25c1de9037a93ddb510e355f90f1a6c6e9" => :mojave
    sha256 "e65c904bb6bd7029f08ecbe69fdbd368c49591b9acdd9bf48f2a473bee501415" => :high_sierra
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
