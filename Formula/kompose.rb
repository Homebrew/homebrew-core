class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/v1.21.0.tar.gz"
  sha256 "64bcb4705e8312c83faaefd8ff4399936e69413662344a683becc2c34d8679f6"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ff94795399d792685bed1a5c0fd4a5b159a0bc0797eac483f3d5218215c26ed" => :catalina
    sha256 "66400a364f4964c4845cc2488767cc9528b75f07a2f1e9ad1bdb59af14914834" => :mojave
    sha256 "64af6730baa77873d2fe402983ebb92cb899f09270cde43a975c5cd109f79d3e" => :high_sierra
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
