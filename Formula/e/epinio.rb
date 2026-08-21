class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "ce86eeb012189f7a03a204a07c03c785d279743c0a9bb3d8ff2beca6344310bd"
  license "Apache-2.0"

  # Upstream creates a stable version tag ahead of release but a version isn't
  # considered released until they create the GitHub release.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d24bffd6977c3b04866e1d39c5160bff420b1ca668d5a83a1a21f9e03837862c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "252f6b4a8abd99fb586b8b407b1ad0685fc587a90272491d6bf6dff9a908ad81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d4f293321a76b1079e610583738981f82226119837bc0c7820ba4d176c6d939"
    sha256 cellar: :any_skip_relocation, sonoma:        "99fe90d4499cedb0f2940e8d4565d879a6152e8f2d6f91b809c687c007e887ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4d2ef2c8d2ca3137e4b3cb50e2985dafac356768955573f669205fee2722720"
    sha256 cellar: :any,                 x86_64_linux:  "d9a4f7af7401d0cba17a00d0123f3495080a879c697fd16ff57541b63cd5cd9a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/epinio/epinio/internal/version.Version=v#{version}")

    generate_completions_from_executable(bin/"epinio", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: v#{version}", output

    output = shell_output("#{bin}/epinio settings show 2>&1")
    assert_match "Show Settings", output
  end
end
