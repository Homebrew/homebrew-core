class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.6.6",
      revision: "0cc88688fee5ce9ffa7365cfa9c102969fdff74d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "e16d023ce23134a3f963207c48758491b8b3d0b69d793d491ca62868cc7b98f1"
    sha256 cellar: :any_skip_relocation, catalina: "5c8e12d137925f1fabd2cc63033d28fb203a83bc22a7583549c4f09c061b5bbc"
    sha256 cellar: :any_skip_relocation, mojave:   "ae9e192a7627f0f17bf4e432eee2c262960cdf0d1c66e69c6ceaa7b4498c2438"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}", "./cmd/helmsman"
    pkgshare.install "examples/example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/helmsman version")

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff plugin is not installed", output
  end
end
