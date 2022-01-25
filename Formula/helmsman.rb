class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.8.1",
      revision: "4d2b79f91b7918f6494754fad448a733932cf788"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e8d9b6e24dc780ae519915aae2663a520240169f1f08fc45230a115c7b17954"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e70efc45c45c8cebd55204018984f1df08285b0a479faef5d03d8133edbd9e4"
    sha256 cellar: :any_skip_relocation, monterey:       "bbf3298a55d52785e2429757ec9a24105a7755aa80d9e39a95301899e532b1c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "2794f851f0496295784e9e230d406e1471e5b8a39ae2dd92c55223604760a035"
    sha256 cellar: :any_skip_relocation, catalina:       "18eb970c45185ed5ddc117a3d2b728772164c8025b05b6824c4d461394353c3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2925f99cc3c1e540cd9d65de11455ef6eb91dc08956126a14c7eeb4a2b88b7b6"
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
