class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.11.0",
      revision: "9887c3853aee56b6803f589e4b426737241ac1e0"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5645aa7dc0d6e907e5f35063a942843f87cd8719c5564e2d99d1cb7184ea836"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b93685a96e10ba72134698f9305c8dd3e033c6271ce47e7d992053c23747c4fb"
    sha256 cellar: :any_skip_relocation, monterey:       "2b5e2fb68ce60f761addf2d2d4c4495c6fd35afe0ba387bb6b311b0f989a4a79"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c6486f43613de1c9d008c627624f3b0ef9cfb596394cbc85d2ab122c88af923"
    sha256 cellar: :any_skip_relocation, catalina:       "705deb8aa51a685954acb54668622f80efdae8e8860a70a96e2c0a881eb3fb77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2208184bd5414004174961b36288d2854f47870b29a6fb1731dcec25e0eb56b"
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
