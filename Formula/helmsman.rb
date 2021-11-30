class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.7.7",
      revision: "321afde41994fb847b36a1da3590d5d405b34f1d"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "442de067a914f57dd6cb9c42b4076866a3aa10ccff22f0e58809168d67aee5cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "528848b28684e57bded1532a99813d264b3f075e1892b2ae726305bbf5cf6a14"
    sha256 cellar: :any_skip_relocation, monterey:       "ff0b1a808cdbeab15d7b08a185ce477e38b2e958d31bed0169ea1b296fdeabdb"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e72b6f0e6417b9a507a1ae5494cc9761196bc5fa807258ad2b4a1ba24add33c"
    sha256 cellar: :any_skip_relocation, catalina:       "434a40e852b61b4b8fc817bde900b8fef6e5ec68ee19455877fb3fdef7cd7ae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df72db51d4c47a769f4906605f6efeaed7f88572696f9c8610ec264b7648b2d6"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/helmsman"
    pkgshare.install "examples/example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/helmsman version")

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff not found", output
  end
end
