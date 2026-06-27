class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/mkubaczyk/helmsman"
  url "https://github.com/mkubaczyk/helmsman/archive/refs/tags/v4.0.5.tar.gz"
  sha256 "d7a49bd4322dfc4f1f8136fe0bcce5ef0bbb9aafe895945580178861fd908ac4"
  license "MIT"
  head "https://github.com/mkubaczyk/helmsman.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70b190cca08b6c8bc0131a07817b87830a41d1462e19fd9f91dfa07dc09accb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70b190cca08b6c8bc0131a07817b87830a41d1462e19fd9f91dfa07dc09accb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70b190cca08b6c8bc0131a07817b87830a41d1462e19fd9f91dfa07dc09accb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccd1a566b468c5104da5842724c13f8a493404df38d3726aee445b4953fdf814"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bb528ab57c7f15aeb7d015589e46f9ba59027a5a7cca3d89fffc7dd09a0366a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "478364859895e1b07a0e3ef573199208e6b83e74abfe9ef15d000c658cef8631"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X github.com/mkubaczyk/helmsman/internal/app.appVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/helmsman"
    pkgshare.install "examples/example.yaml", "examples/job.yaml"
  end

  test do
    ENV["ORG_PATH"] = "brewtest"
    ENV["VALUE"] = "brewtest"

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff not found", output

    assert_match version.to_s, shell_output("#{bin}/helmsman version")
  end
end
