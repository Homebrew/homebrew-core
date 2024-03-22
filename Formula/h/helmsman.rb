class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.17.0",
      revision: "85824a11ac957153badc2d9ca8db94ce6660326e"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04c03b758cb3971548ff178ffd8285f12e192161b5451d78ba1419e0f17434b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85c666a66ec54f35c34a5311eff4042ad36fe27220f48634d7f5636787999ae2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85c666a66ec54f35c34a5311eff4042ad36fe27220f48634d7f5636787999ae2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85c666a66ec54f35c34a5311eff4042ad36fe27220f48634d7f5636787999ae2"
    sha256 cellar: :any_skip_relocation, sonoma:         "128891c5da8c3c1541701d5b95a4fa993cca79a10eeaf5556e306fe8cc5119cc"
    sha256 cellar: :any_skip_relocation, ventura:        "c036c5e39725f10ef031c6bca477b3ca2d054c0cac6ebafe5ff27befde1c4f76"
    sha256 cellar: :any_skip_relocation, monterey:       "c036c5e39725f10ef031c6bca477b3ca2d054c0cac6ebafe5ff27befde1c4f76"
    sha256 cellar: :any_skip_relocation, big_sur:        "c036c5e39725f10ef031c6bca477b3ca2d054c0cac6ebafe5ff27befde1c4f76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0631bc389964a08368c508b767ce83e3548e196cfc3bdb61147d8ace9538849"
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
