class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https://glasskube.dev/"
  url "https://github.com/glasskube/glasskube/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "a12c672a900cc725a7b7566cbd844a0406e69c42b2334710fec098cda8b8452c"
  license "Apache-2.0"
  head "https://github.com/glasskube/glasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ede0889012b158d2639177fea87493460a342018e81f8cc893aefeccea6f066c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcbb764e1b2b99d1e068fe0771d2b135e13b4bb715b57135dfc403f39d7b5dc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4796e72ea003d1a13609cb7f735a843f263cbee36e13afe4168b392e72660c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "d754618092a67fb2f49c88f8ee1360848b47af9da8b92dbfe55f9bc26445c8ed"
    sha256 cellar: :any_skip_relocation, ventura:        "aba6abdb0df865693b257442e1a2acde7e3fb88cff626d21639cb8b29e33deda"
    sha256 cellar: :any_skip_relocation, monterey:       "fcc628b05ed55ac5d71abd2bc1ce1c571b43a43328db69bac0044007d12f8744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "615f59d4aa321a0e104f65c1d0f5f78fc85f0b6b0df736530509a83f1e0b0edb"
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
