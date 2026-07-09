class Plakar < Formula
  desc "Create backups with compression, encryption and deduplication"
  homepage "https://plakar.io"
  url "https://github.com/PlakarKorp/plakar/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "3991e0bec18fa098d6a6450e68a6bda21fb2541f9ec95e543568fe23ad78ab6a"
  license "ISC"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00d0e67047109b1fb4ba8d52520169ceaaf185c53953c5ff388637d72fde1a36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd09a166bc4fdb371d720088cf0f283c6d413a75082622c7a21b6b45de658158"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccde0cba4e20d496c577bbffb088b11845d120c450335bc60038d5d919694ff3"
    sha256 cellar: :any_skip_relocation, sonoma:        "74ec6d8f6ff5ce7377532d17eada3343c6146483be984f2537ac32b5190c5c15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62795975fe20d93d918b95bee8e1c925b8630b347ce87a421a31560f25593c7f"
    sha256 cellar: :any,                 x86_64_linux:  "9d5af84ab961a3c448c817818ebc309433fa6e5f8a50187552fb0663d9afa1c1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plakar version")

    repo = testpath/"plakar"
    system bin/"plakar", "at", repo, "create", "-plaintext", "-no-compression"
    assert_path_exists repo
    assert_match "Repository", shell_output("#{bin}/plakar at #{repo} info")
  end
end
