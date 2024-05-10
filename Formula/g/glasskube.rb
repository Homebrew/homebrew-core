class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https://glasskube.dev/"
  url "https://github.com/glasskube/glasskube/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "5e1b0fd11563739af44794faeb749f16d818325f53e527106f52c51024956b7c"
  license "Apache-2.0"
  head "https://github.com/glasskube/glasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eaac51d3a429c639d9f655a078a4d7b1e57431c15aa1ac9fba4b53de4658421a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6dc26b3b6bd455a2df7416e1acac6e82757fa380ddd60768796b57632af69f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6a400338236073e4c8bfd90270d65940e2bd9af493d07a05b8a3ccc5a6fb054"
    sha256 cellar: :any_skip_relocation, sonoma:         "921ab62767371143afa445a13218059b9f2bb174ff2fa50c4e52a34b72c23c5f"
    sha256 cellar: :any_skip_relocation, ventura:        "6920bf4448cdbc90ee30a96dfb408ebf1fc01fc46475f7e7458b47686dbcb2be"
    sha256 cellar: :any_skip_relocation, monterey:       "598341dfd1b7f7f04852004cc70a01d8cce96f9dd2380d4a899f0697e63f11c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b92ebdb5c9911ff2c125f5d871d5632d4ad01114c47ee85041972c20fb5a959"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/glasskube/glasskube/internal/config.Version=#{version}
      -X github.com/glasskube/glasskube/internal/config.Commit=#{tap.user}
      -X github.com/glasskube/glasskube/internal/config.Date=#{time.iso8601}
    ]

    system "make", "web"
    system "go", "build", *std_go_args(ldflags:), "./cmd/glasskube"

    generate_completions_from_executable(bin/"glasskube", "completion")
  end

  test do
    output = shell_output("#{bin}/glasskube bootstrap --type slim 2>&1", 1)
    assert_match "Your kubeconfig file is either empty or missing!", output

    assert_match version.to_s, shell_output("#{bin}/glasskube --version")
  end
end
