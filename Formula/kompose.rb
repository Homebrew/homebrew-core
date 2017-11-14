class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes/kompose/archive/v1.4.0.tar.gz"
  sha256 "29ea870886bac78850a6b7a864ece63b3f67ed769358193d5ea12c8b0d197f82"

  bottle do
    cellar :any_skip_relocation
    sha256 "0386945efe36c8d20ca0ac36af7f10ab70c42cbcae741981a711da46b6318b4d" => :high_sierra
    sha256 "7a433e3aa759039c2f2340c5a2d627e295ddb27ee22ee3162c574a6be32d641a" => :sierra
    sha256 "c784ee4a5f45721e76fca2f0abc7df00d8e4c488409a6fbc1da38983cfc67cb5" => :el_capitan
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
