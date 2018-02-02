class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes/kompose/archive/v1.8.0.tar.gz"
  sha256 "f833bd7c0459aec7416d8d511360cc0773425c87d1c64ac40211cee1a5c30c63"

  bottle do
    cellar :any_skip_relocation
    sha256 "d71defa99aeb19ca7f514cfdc5ecc98b5cfb5ba17dde4808431985c89e85b070" => :high_sierra
    sha256 "96bbc7554c2109d3d4b92847bde14dccf13b334f53ff1b6376201f1660740c4a" => :sierra
    sha256 "d85ef67b16ca84f17f916d42df0526028920bd2ca05eb5fbe5dda12d1c91b157" => :el_capitan
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
