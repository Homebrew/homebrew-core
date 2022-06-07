class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.11.0",
      revision: "9887c3853aee56b6803f589e4b426737241ac1e0"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8b8b2c13f9b2212883c2b9f2f7c3a24dcabeb9ec9132688f24aac165a79e81d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "282280abd1933815e2333b1e67cbc90f9c3c21bd6f34082f5aad98ee4fbb2608"
    sha256 cellar: :any_skip_relocation, monterey:       "e751ecd1133a3be16698cd65897c463bec0592f3a9702440be344918f2ee69a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "7aac3468d04092ec706a29a63b3577bafea833093b9be89aef6ff615481c2db0"
    sha256 cellar: :any_skip_relocation, catalina:       "09bc1c344ed05043de9bc71c62ca914a7cba7547bb1b459d79e073ccfa506ba6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5edb121e39111fa475f2d315c11423d894b00c522a57682142913edcffc03f27"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/helmsman"
    pkgshare.install "examples/example.yaml"
    pkgshare.install "examples/job.yaml"
  end

  test do
    ENV["ORG_PATH"] = "brewtest"
    ENV["VALUE"] = "brewtest"

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff not found", output

    assert_match version.to_s, shell_output("#{bin}/helmsman version")
  end
end
