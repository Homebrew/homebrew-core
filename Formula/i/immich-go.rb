class ImmichGo < Formula
  desc "Alternative to the official immich-CLI command written in Go"
  homepage "https://github.com/simulot/immich-go"
  url "https://github.com/simulot/immich-go/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "1c07ce22e5b46e3691867025154751063d4b9e4cf5df6ef4335102711e017d92"
  license "AGPL-3.0-only"
  head "https://github.com/simulot/immich-go.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffb24c673722ada9e0aeb7c771a2c088ad54c7980d59083de38d3d1e1edd65c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffb24c673722ada9e0aeb7c771a2c088ad54c7980d59083de38d3d1e1edd65c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffb24c673722ada9e0aeb7c771a2c088ad54c7980d59083de38d3d1e1edd65c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "36d8ce999b1bcabc12e8b82dd3d447949d5c44759a7cd34a2018092ec6cc9ee5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "084b77b1f63518f4ef40e0f5f872b1fc2914765e8011618cb7abf48fec624f64"
    sha256 cellar: :any,                 x86_64_linux:  "f3b8aceb220fbd5b6b0d2efc3b6b0401aa35cfac7ac074a56e713d2ebda4f181"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/simulot/immich-go/app.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"immich-go", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/immich-go --server http://localhost --api-key test upload from-folder . 2>&1", 1)
    assert_match "Error: error while calling the immich's ping API", output

    assert_match version.to_s, shell_output("#{bin}/immich-go --version")
  end
end
