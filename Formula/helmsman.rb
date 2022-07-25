class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.13.0",
      revision: "a849965375d2115ded3d8653f42c29f1621e1dce"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75b7d221b0e0c7173e20046e0ec77bcdabb5d763041d8fc47b4995790314dced"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8692d7b607a83476108ae63ff14ab573d607913ca54b5e4f797fe7210e692f93"
    sha256 cellar: :any_skip_relocation, monterey:       "eaf8895969daab38b3dc8fdaa22948df366028b3caeb869a65f8899b412adc2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f8fd77200bde73a98bcf287a5505aff8d520f94f71257ee88907db3e6098b06"
    sha256 cellar: :any_skip_relocation, catalina:       "2e4c7d22522009eae87aa3327cc85b78482d1e7fd0a2e80212d8065a348fe7c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2c0f7c45c760442b7948517938fe2c4508df1fd3ce770e0cef4ff4ae589b4ad"
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
