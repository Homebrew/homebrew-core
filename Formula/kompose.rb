class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes/kompose/archive/v1.11.0.tar.gz"
  sha256 "f74ac2061fb535cb35f09ad1971684692816e6cf79d559b716824a3ade3a39df"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc69957bd59ac3abaebc75117fa5f907b63b2ce1b910250aa34a05d45a8f139f" => :high_sierra
    sha256 "d7c87e233736b65de5652783958eb2796b13234ee408151e4e26ac4df21cdb37" => :sierra
    sha256 "4dc9eeff2221913c230985d3950566a0ec411e72651441b18fd844d6f268c5c3" => :el_capitan
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
