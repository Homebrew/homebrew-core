class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/v1.16.0.tar.gz"
  sha256 "b892e2d685570e18f19264f8a37afde32382466994dba90e68057618941f3961"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a66f7d62639f5b4006ccd6a6cb642b1e85710765c17ab712f895ef8bcd9a3e5" => :mojave
    sha256 "7145d8df93bf1772cbb5b826a6841488a594c4ef478a71a66c865e078af23475" => :high_sierra
    sha256 "e9232115913c414ab9feaffee2bd79941e19c0f4344105482bc5ace2799f0912" => :sierra
    sha256 "3b86936f56b37ffc35f272163ae3f9b04c277f88cfe404ef9291f1fa3572579f" => :el_capitan
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
