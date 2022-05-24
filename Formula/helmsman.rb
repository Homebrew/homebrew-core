class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.9.1",
      revision: "6c4a6b08354111e21fa411f98b063fbd896c3ffa"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38568751ebcc6110853ca1715826bb669f831e098ed603e18abe42960406ea42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43cd32cd69afdd7bbb727dad5baed3e4b179f5b5339f17f7a86c282a302948ea"
    sha256 cellar: :any_skip_relocation, monterey:       "eba17c1ca148a896880e7332f1a85471f0bc8462218af99cd0efc6aa2c1baa59"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e75524dfb84d4e4e7ae993960349d84d56d6e914e7f439ac389840e041d6bcf"
    sha256 cellar: :any_skip_relocation, catalina:       "2bcf0f61cfc1177a0fef824dc55f8930bb1082a69c57f92b7a2e6cde40152fcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bd2c16a145d7b12e6563a529aba98fd0f7a0508e2dc50e50c0b2e4943e4f3ef"
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
