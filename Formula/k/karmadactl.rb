class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "e52417191a0241bbd650d53dd8089d61c524dad11b730d0468cef81d360282ff"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb03f4bf5f1c5e43f7e4c4e9711f273d978d17057970eafc914192ced68ae540"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98289686d9537a736fb0baa9e0d82893f229062d35ee0f828f3d2b50e1714f07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "475bbdabe5482f9c542f42aac70186ea50d1b7d6ccbd3962e554b79a6efe4627"
    sha256 cellar: :any_skip_relocation, sonoma:        "be391ddb776ea4b2c20f8c9482d566f241f5368698d25216d6022c30560d7310"
    sha256 cellar: :any_skip_relocation, ventura:       "e9b69ef539ef48965637a930875d5f9b5c5cd3ac7b7908701ab556089d15af6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94d73764979161cd2bd92de6000f0e51b90016fe11560aaf01cb6426c7d5d4dc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/karmada-io/karmada/pkg/version.gitVersion=#{version}
      -X github.com/karmada-io/karmada/pkg/version.gitCommit=
      -X github.com/karmada-io/karmada/pkg/version.gitTreeState=clean
      -X github.com/karmada-io/karmada/pkg/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/karmadactl"

    generate_completions_from_executable(bin/"karmadactl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}/karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}/karmadactl version")
  end
end
