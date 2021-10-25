class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.7.7",
      revision: "321afde41994fb847b36a1da3590d5d405b34f1d"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9bd907c706ea618b05f9d7aa24c9bd579d4ca97711708b5e20866776ef3b0781"
    sha256 cellar: :any_skip_relocation, big_sur:       "0cca366c21ad6047673613b9348ae08b85491d5ffeffc827279f455b7e91e40b"
    sha256 cellar: :any_skip_relocation, catalina:      "26901bd4bbf7529838a6243e7b2bb41a0501ff038d0a75b7962756ce7a1dc21d"
    sha256 cellar: :any_skip_relocation, mojave:        "fb01da98d62cb429b74c06f3a790170d72696a9003f18d76291fa09a5870e086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96f6ae7ca9ba1a351e2c162c8e1a3878e3b9856d99a34029e29e541ecb4c466b"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}", "./cmd/helmsman"
    pkgshare.install "examples/example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/helmsman version")

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff not found", output
  end
end
