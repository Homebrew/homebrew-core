class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.6.6",
      revision: "0cc88688fee5ce9ffa7365cfa9c102969fdff74d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cb2ddce9b90dc2b30ca849d38d8272a0baca66dbd195e87c8ca176ea6149ecf9"
    sha256 cellar: :any_skip_relocation, big_sur:       "5cab3e8e985577a7acf2d36e9ce8f21a693ba3bdabe2ba10c08da7761118ee24"
    sha256 cellar: :any_skip_relocation, catalina:      "01f18335cdfb21fceb613da2e39a25319658f37ef5820824d0fbc4ee2368698f"
    sha256 cellar: :any_skip_relocation, mojave:        "8de309a5d1358eaac1dcca2b9d1a89cd4fcf694ce71f70f8fcc7d44bb24a95e6"
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
