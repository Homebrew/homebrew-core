class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.9.1",
      revision: "6c4a6b08354111e21fa411f98b063fbd896c3ffa"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55a6987b22948a149f9b95bc2187dc1c07033cdedf09b4b67b847b781d2968c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce15dcc5ef543f1faf389cf2a6a84e3af4f2e0cedf3b21dbaec044513e493fa9"
    sha256 cellar: :any_skip_relocation, monterey:       "aafc7154901585cf692d4266eed7f78a040101e650d312540132d65ce0a4753e"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c63a491922fcef87f97395291553e3eef49486a63021f5ece9f67dfd3fb63e1"
    sha256 cellar: :any_skip_relocation, catalina:       "3bd9a345adac6f6977eda54980ad75da4c1785fe24e4958ab7e5ff549b3735e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a015e7da0633081b1be20da14f64b7452114d31a291cba139c2e32e1ed851beb"
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
