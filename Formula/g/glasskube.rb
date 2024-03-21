class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https://glasskube.dev/"
  url "https://github.com/glasskube/glasskube/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0508423982723e9b28d73f14ecf0f5f2bdcca2fc45616a09922c1601d4eb2d78"
  license "Apache-2.0"
  head "https://github.com/glasskube/glasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd73f05c6982fccd05194c762d4f7993123c6b9d56cd17e21ab63f1d91093106"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a303f24db999d82c9afa0f6925ec7e449d4dd7a9c8b63b74b30c05667008f766"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e26fdc21e12884d02d0a9401a34a9b7a7bbfa915f827b8993b8de209c5efc66d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4aa05215e34f49a8773faf88c0de4819c0db182290d690929bd10f8e6f4b5ff1"
    sha256 cellar: :any_skip_relocation, ventura:        "4653fa2992ef085273a01aaab47b866c405fbbab258c9ed5bcaa9b7ebd229f7f"
    sha256 cellar: :any_skip_relocation, monterey:       "abc0f0a69f835d409f97d848f04d89e1314a5a4fc6067dda2840f02cdd658195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7086e12bd78503d712983c87f41d605a6166aa9275e10b8965898e386113bb8e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/glasskube/glasskube/internal/config.Version=#{version}
      -X github.com/glasskube/glasskube/internal/config.Commit=#{tap.user}
      -X github.com/glasskube/glasskube/internal/config.Date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/glasskube"

    generate_completions_from_executable(bin/"glasskube", "completion")
  end

  test do
    output = shell_output("#{bin}/glasskube bootstrap --type slim 2>&1", 1)
    assert_match "Your kubeconfig file is either empty or missing!", output

    assert_match version.to_s, shell_output("#{bin}/glasskube --version")
  end
end
