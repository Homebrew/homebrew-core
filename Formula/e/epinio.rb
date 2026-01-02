class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.13.7.tar.gz"
  sha256 "2a76233b9505b56412b6e0c94262f5e280ee994f52b274b91d2d3885f5167896"
  license "Apache-2.0"

  # Upstream creates a stable version tag ahead of release but a version isn't
  # considered released until they create the GitHub release.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6634c1b50ca56326cf6972bc6cbb00b72d2c687879816fb1c30014c249d70e8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8d179beda7dbebd211631c39cb1da1cc4d8fd138f229845586399d7172abef1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03f0b131dcbf2ae5b43c553627fa6c535123b11408bb0a254e1838b6e0690567"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba539952ea1a339af9c5fbc464386175b901f0c4ee125b3bfe5697c70def458a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11f036b953fa0298f4957da7750ea9393a28b4b2a9b57cac93b903541a10258c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89ac73af25520c414d02ea261c335e1df4c8499af33dfbf1ee9f88e45e9d6466"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=v#{version}")

    generate_completions_from_executable(bin/"epinio", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: v#{version}", output

    output = shell_output("#{bin}/epinio settings show 2>&1")
    assert_match "Show Settings", output
  end
end
