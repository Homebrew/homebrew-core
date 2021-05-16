class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.6.11",
      revision: "039f7145b6bcce3117acedd3a4f8f2cb240c00e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fc2de1279990f7ca275807bf838168c9b476239b7f85029c33611e84ef29899f"
    sha256 cellar: :any_skip_relocation, big_sur:       "5cbc3d88ad87492935e8acfc8ba38930d049f0ddae983d6b0c389321005e7052"
    sha256 cellar: :any_skip_relocation, catalina:      "46388ac364757215acfa2ca380d059cc0b3b9dd58249c1ccb42f82fb97aeb42d"
    sha256 cellar: :any_skip_relocation, mojave:        "bfe8e401f747e016e0c292d40217640aed8a89c4f97cf42ce318d52c73418673"
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
