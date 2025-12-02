class ImmichGo < Formula
  desc "Alternative to the official immich-CLI command written in Go"
  homepage "https://github.com/simulot/immich-go"
  url "https://github.com/simulot/immich-go/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "b24fd12f28d9691853cae1f48ff846b33794a36a4d356912060d019314789fd4"
  license "AGPL-3.0-only"
  head "https://github.com/simulot/immich-go.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d921b5c5a96b8797f29f37ea80f35e96fd3322585b87cd98d6cd378379780e04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d921b5c5a96b8797f29f37ea80f35e96fd3322585b87cd98d6cd378379780e04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d921b5c5a96b8797f29f37ea80f35e96fd3322585b87cd98d6cd378379780e04"
    sha256 cellar: :any_skip_relocation, sonoma:        "be6741530f0e6350b1bcfc51612524fb79dfc0160cf7dff5dc6659d587f92768"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1090d16b91b9f6abcbdd2a94582727bde6ab378b916f70e7ef2d9b413ed2bf77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ede3d32fc5faf80f2237b25fe2971d1b4a69aa91b1c8c618a53f7c9d6ae5797"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/simulot/immich-go/app.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"immich-go", "completion")
  end

  test do
    output = shell_output("#{bin}/immich-go --server http://localhost --api-key test upload from-folder . 2>&1", 1)
    assert_match "Error: error while calling the immich's ping API", output

    assert_match version.to_s, shell_output("#{bin}/immich-go --version")
  end
end
