class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes/kompose/archive/v1.6.0.tar.gz"
  sha256 "57a8d5f2db642fe7b3812b17867c8ad32a6dc8facd165b196e6505a41e300f3e"

  bottle do
    cellar :any_skip_relocation
    sha256 "b89da8d742d7010b550c927f9a19556c1e444b4d0879abfae42c67ef69271f36" => :high_sierra
    sha256 "3eb3fd6ca8b58822f803ecba2b09be16a02d4a56aa53a0df7bc4e072b84bafb2" => :sierra
    sha256 "bd07c5d77512b4fa2a15b01ec051c2503525bac12ba36c8401231cf4d2621ebe" => :el_capitan
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
