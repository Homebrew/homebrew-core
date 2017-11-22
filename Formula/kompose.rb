class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes/kompose/archive/v1.5.0.tar.gz"
  sha256 "a55cbf0b0359b56a1ca6444d4a0ce7e73e0d89766a6bd75e8ed29af3cf317bd2"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1c08e503104f73b3a5df1cb1ca48c95b10fdf5121ebdbd3d89c0592467366b46" => :high_sierra
    sha256 "7b143c9f8ce85343ba279c9b0f647085ab65866a6f80b30ed24188e1e5a6109a" => :sierra
    sha256 "879f93a28c1ee5f655e0e01f15fbba816bf62f3742b6e2483e5e3427d5a6c0c4" => :el_capitan
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
