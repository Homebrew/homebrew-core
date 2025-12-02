class Plakar < Formula
  desc "Create backups with compression, encryption and deduplication"
  homepage "https://plakar.io"
  url "https://github.com/PlakarKorp/plakar/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "5f9af49e9957b2fc659f0c9192db748785c95a1319290e69469df971fe3eeb9e"
  license "ISC"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ac2ddfcbe2e5115613e19f9ce5a2d356bde679a58bd62326547270738d385ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f2484b9522dcb6dddd7556d144543fe388b4c14ad1016011ac532ce81080eb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cb963f9a0ccfba98ce9962e0da149d412e362f7e3e13e136950bda9e68e093d"
    sha256 cellar: :any_skip_relocation, sonoma:        "774c10fedc3449a8e8ba3dc685cda56f8718c2153d0a10d808ee3100abed722b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b00e5e2583a6d7bc026cf53cd608c74fa1a38b444f0edcc74ae2d62028393570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16b675f1981fe537ff5bd71ff616ce61abd72ee89c4f18c18a4bc7549056fab6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plakar version")

    repo = testpath/"plakar"
    system bin/"plakar", "-no-agent", "at", repo, "create", "-plaintext", "-no-compression"
    assert_path_exists repo
    assert_match "Repository", shell_output("#{bin}/plakar -no-agent at #{repo} info")
  end
end
