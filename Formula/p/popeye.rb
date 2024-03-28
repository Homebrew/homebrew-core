class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https://popeyecli.io"
  url "https://github.com/derailed/popeye/archive/refs/tags/v0.21.3.tar.gz"
  sha256 "9f8f5b46a942ec7fcaf777ec7f16e6d64317cfdc7080e3d637018d778656ee94"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc9b26b43fc91067ebf4a5c39e0326fa77637ec4f0b3d6cd44e543bb7f2e94fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2240a4317ad953f08642deed1e4155aceb921bf2b2b8a6d3adb58b2602b7240c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73efd455efcb25766afadee9ea50286fe0598cd53adec7b31eacf7e5b4d35d30"
    sha256 cellar: :any_skip_relocation, sonoma:         "1915c4db3a9e5a51ab8cfad694f5bb93a1b21c5ad4816734edbde9fa5f0d618c"
    sha256 cellar: :any_skip_relocation, ventura:        "612214672ece1851568821efbabd314cb96cc293c686c9723578dcf333e915fa"
    sha256 cellar: :any_skip_relocation, monterey:       "45d5ea2df07c4706c6d3cbe1826a58014e6be8384e6c3d155f997276f2ddc05d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "766e4649aabbed1589d86a72a8f9f53bcdf5139195f71aac9ea871f4a573ce78"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/popeye/cmd.version=#{version}
      -X github.com/derailed/popeye/cmd.commit=#{tap.user}
      -X github.com/derailed/popeye/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"popeye", "completion")
  end

  test do
    output = shell_output("#{bin}/popeye --save --out html --output-file report.html 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/popeye version")
  end
end
