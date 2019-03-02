class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/v1.18.0.tar.gz"
  sha256 "6da3ba8b66c7023f66b3ddc8f9ff1e5ce5f38e299da9ff93c4dd1c2a765b8dc5"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5aa21a04462d384e5eee491c064417868a987643e483d0abdf63b34ff1ef384" => :mojave
    sha256 "cca8ebca8fc06f5b756f8c507b69b4cf1e4dd43b8d77cd1aa42fb2a33e931e36" => :high_sierra
    sha256 "1da9458290ae98190c8b05bc43542fbc6aae5f0a18ee6b5f1a2e58b44647ee73" => :sierra
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
