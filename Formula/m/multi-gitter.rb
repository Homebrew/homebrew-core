class MultiGitter < Formula
  desc "Update multiple repositories in with one command"
  homepage "https://github.com/lindell/multi-gitter"
  url "https://github.com/lindell/multi-gitter/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "30778c3ae4ac8dea7f9e93ed0b8cb9f081163c2b3568c2a91330dea438ed1b07"
  license "Apache-2.0"
  head "https://github.com/lindell/multi-gitter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "561b016ae6543d4a7b34ab92e86ebee28e455faf55a59dd1d491e2f3099d0c98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "561b016ae6543d4a7b34ab92e86ebee28e455faf55a59dd1d491e2f3099d0c98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "561b016ae6543d4a7b34ab92e86ebee28e455faf55a59dd1d491e2f3099d0c98"
    sha256 cellar: :any_skip_relocation, sonoma:        "823f697c43e3644b3d3d2058d6d0ae27fdd0dceb1af965b27f08c9901163b264"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2c0d7a8e68fa1e341e9fad5620921b308299f11e8348a18ec02ef1f65940530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0642808cacf6f1fea45b35289f9eea22fcf30acb71558e6d6f790992567bb779"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"multi-gitter", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multi-gitter version")

    output = shell_output("#{bin}/multi-gitter status 2>&1", 1)
    assert_match "Error: no organization, user, repo, repo-search or code-search set", output
  end
end
