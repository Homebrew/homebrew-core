class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https://glasskube.dev/"
  url "https://github.com/glasskube/glasskube/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "2a3c30777dc21333d07f4cb2b0882823bad99b5142dc13d32f7b700b00abb3f3"
  license "Apache-2.0"
  head "https://github.com/glasskube/glasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bed4bac71a05c4bed2274ba076130e7d95de294b499a73d6cc2ac1d9a0637708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bed4bac71a05c4bed2274ba076130e7d95de294b499a73d6cc2ac1d9a0637708"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bed4bac71a05c4bed2274ba076130e7d95de294b499a73d6cc2ac1d9a0637708"
    sha256 cellar: :any_skip_relocation, sonoma:        "d50dfc262768fd3fed1dec5727c4f65f1f049eab58d32db1e03bc2a86510075e"
    sha256 cellar: :any_skip_relocation, ventura:       "d50dfc262768fd3fed1dec5727c4f65f1f049eab58d32db1e03bc2a86510075e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b52491b8e7f9352eee1e1643b087c1e938e831b2066b13c7e255a05fba195dd"
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
