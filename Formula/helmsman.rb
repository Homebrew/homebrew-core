class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.9.0",
      revision: "4ff303ac0b0a2abe43cd01a17765b4d86ffec2b5"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c0bffe4590f4064bcee5cdd615d87c65eda9a7f44837bb663f208f15666c95f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "012b92a191bc6d9a96c018fdbf604b8de0ac5ba4428349bb3f1956fef2734920"
    sha256 cellar: :any_skip_relocation, monterey:       "9e29fedf90cd6f9800c5930ce40ca4aaae014ce07f3485d5c282e22d347cd6f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbdcafa3305f818015e7d655c63f688b5930f597e18bc3cf91425bc5046f8456"
    sha256 cellar: :any_skip_relocation, catalina:       "577e5b987747172367437dcd4a45e9ff1eac372db0bee529916dd8b7cd67ad70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d204579056de1a153f5b4ac6575a052f99fa4c79d4541f5dae45021c34780a3"
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

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1")
    assert_match "helm diff not found", output
  end
end
