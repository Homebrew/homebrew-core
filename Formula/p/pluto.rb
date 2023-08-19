class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/v5.18.2.tar.gz"
  sha256 "6e1171107b432c3c4711ffd028aa4e5d7263b53f0c1df48f9b4bb68796d41168"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b53715db865d8f975cbe9bb01be31030aaca29304a394ff53447421ec1b3893"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b53715db865d8f975cbe9bb01be31030aaca29304a394ff53447421ec1b3893"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b53715db865d8f975cbe9bb01be31030aaca29304a394ff53447421ec1b3893"
    sha256 cellar: :any_skip_relocation, ventura:        "06d81c9e782e5490c293a947d4dfa381d76af2c03333fcb1fae39604278c78e6"
    sha256 cellar: :any_skip_relocation, monterey:       "06d81c9e782e5490c293a947d4dfa381d76af2c03333fcb1fae39604278c78e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "06d81c9e782e5490c293a947d4dfa381d76af2c03333fcb1fae39604278c78e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65f781aa8fd2f70d8dd71a6bce0166434e8e1f61edee4bfaf0c5be9c7f58633b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/pluto/main.go"
    generate_completions_from_executable(bin/"pluto", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluto version")
    assert_match "Deployment", shell_output("#{bin}/pluto list-versions")

    (testpath/"deployment.yaml").write <<~EOS
      apiVersion: extensions/v1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    EOS
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml")
  end
end
