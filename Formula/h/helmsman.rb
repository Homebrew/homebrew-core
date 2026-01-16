class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/mkubaczyk/helmsman"
  url "https://github.com/mkubaczyk/helmsman/archive/refs/tags/v4.0.5.tar.gz"
  sha256 "d7a49bd4322dfc4f1f8136fe0bcce5ef0bbb9aafe895945580178861fd908ac4"
  license "MIT"
  head "https://github.com/mkubaczyk/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5726091c1d85cb3dc4c45599dbcc08e47af8a683371fb2f8386ac51f2580d84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5726091c1d85cb3dc4c45599dbcc08e47af8a683371fb2f8386ac51f2580d84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5726091c1d85cb3dc4c45599dbcc08e47af8a683371fb2f8386ac51f2580d84"
    sha256 cellar: :any_skip_relocation, sonoma:        "76b5e3db809e503f3fad4d4c48b446ca06e50b1d5d09aa39282d89cc9cd083a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b37efc52815db6e43ed2989f86f024ad752ae29195eb07902f4063972bbea4c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e0cd0b6fdfa5d0b2f5824f5d41434f4bc89380ccc8e1d1e4eae6c0571ae9be1"
  end

  depends_on "go" => :build
  depends_on "helm@3"
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
    ENV.prepend_path "PATH", Formula["helm@3"].opt_bin

    ENV["ORG_PATH"] = "brewtest"
    ENV["VALUE"] = "brewtest"

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff not found", output

    assert_match version.to_s, shell_output("#{bin}/helmsman version")
  end
end
