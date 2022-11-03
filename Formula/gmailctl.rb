class Gmailctl < Formula
  desc "Declarative configuration for Gmail filters"
  homepage "https://github.com/mbrt/gmailctl"
  url "https://github.com/mbrt/gmailctl/archive/v0.10.6.tar.gz"
  sha256 "85757469561fd612209c8d7c5146b4a23d377d236a918c1636113c3d115acf60"
  license "MIT"
  head "https://github.com/mbrt/gmailctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "242b5d9b608d2d0343ce5ce97565e66b43ce870ee29c72c3165ffc4987bbea02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ecc6c847e17f4b7765fdc982867fe37fdc7e13c3f1165e9d9e910cd7355d330"
    sha256 cellar: :any_skip_relocation, monterey:       "ae95ae7e0ab186485c25de9a8ea1e2e2ac0cf2d7bd3f735cca469843a0b355ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "2199b8b8582bed6f14e168dfee52fe25843d4b7a770b98fcd5e4e57a8d0faccc"
    sha256 cellar: :any_skip_relocation, catalina:       "c3fe50ae848c3d723321c948236d53f2564c415b023c278916bf79b32a5e2b97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6808cbf4b37bb57f4b98527cbddbf466addba0fa59573866826bd8c9f3b90ce4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "cmd/gmailctl/main.go"

    generate_completions_from_executable(bin/"gmailctl", "completion")
  end

  test do
    assert_includes shell_output("#{bin}/gmailctl init --config #{testpath} 2>&1", 1),
      "The credentials are not initialized"

    assert_match version.to_s, shell_output("#{bin}/gmailctl version")
  end
end
