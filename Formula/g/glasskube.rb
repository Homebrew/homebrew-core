class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https://glasskube.dev/"
  url "https://github.com/glasskube/glasskube/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0508423982723e9b28d73f14ecf0f5f2bdcca2fc45616a09922c1601d4eb2d78"
  license "Apache-2.0"
  revision 1
  head "https://github.com/glasskube/glasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1120dc5c376222ea6ea02e83ed56cda7fb384aec8550fd9ba81ca63f95808196"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90a83459f7e09212fc717e5b31e80ab3ea73561a2d73bdba463790f203c0d76d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1c87c2ae593d9a0f6b40ac3dd9a7053fa0530ad01fc053f834818af14b984c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "c718f3d3a9c3853a9eaad1ec6bd26bafb88a89080cab0c03fef9311da509e279"
    sha256 cellar: :any_skip_relocation, ventura:        "717a80306a0522383894934dba287d14009bf477d5f834f630e23eef1a25a5c7"
    sha256 cellar: :any_skip_relocation, monterey:       "36f578d72949d4f1657c45704af6cbe8d49a09f20a9d61ffe139cddffe571a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "147a1a5b955218532487eb8094e998a8735c0cf2dae9257d574132b01295185a"
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
