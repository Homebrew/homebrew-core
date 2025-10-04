class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "f93fa90ab4791610b1aab9c11aef288fffa146b1fbba95de63b6b3a1fe78396b"
  license "Apache-2.0"

  # Upstream creates a stable version tag ahead of release but a version isn't
  # considered released until they create the GitHub release.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c18f3f251b108c95741491959588fb17fd69a28dab18ab42a80c2611a6e157af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a61a77fc1728baadf1f9529802a145a44f2de69311efa7508c903f650a8e4d76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65ffe6637693495f318c009dff3904c76ae519d83411ac65811974cb990bc1f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3803f01921a52f44d2bc42eb10720a98ad3c4baa1e66dfdf5955dc0612da678b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10e9f175c966dc9541fcdf492f895f1ef887a606bb9bfb1be00f2353f2eedb1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ca45d0ad2b82684678f7eb4923ca5cf8e83abafc0b5a5a76d87ea10b25b62c8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=v#{version}")

    generate_completions_from_executable(bin/"epinio", "completion")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: v#{version}", output

    output = shell_output("#{bin}/epinio settings show 2>&1")
    assert_match "Show Settings", output
  end
end
