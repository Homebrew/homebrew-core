class GitWho < Formula
  desc "Git blame for file trees"
  homepage "https://github.com/sinclairtarget/git-who"
  url "https://github.com/sinclairtarget/git-who/archive/refs/tags/v1.3.tar.gz"
  sha256 "7af9950b8786a52e71e80457986f8b961064dc39923de1e330bc9fede42feef4"
  license "MIT"
  head "https://github.com/sinclairtarget/git-who.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec34f46d1792d480bc256dfe1bdc810e533f97433ddbd6ac219b8a7c4d2c3789"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec34f46d1792d480bc256dfe1bdc810e533f97433ddbd6ac219b8a7c4d2c3789"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec34f46d1792d480bc256dfe1bdc810e533f97433ddbd6ac219b8a7c4d2c3789"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a5f6d518915a9fa085664721c1df20b578fe8bfa36c7f104e07600321ebeca2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "024b64101d871ea36214c5a63067d3a07a42f2fe30fe216f6f0bdfff122a077c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebf7f36b22aff6e4fd4b8b2575680e00f02e674b808cd7d8cc3d92ddf92241f7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-who -version")

    system "git", "init"
    touch "example"
    system "git", "add", "example"
    system "git", "commit", "-m", "example"

    assert_match "example", shell_output("#{bin}/git-who tree")
  end
end
