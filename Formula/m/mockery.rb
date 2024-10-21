class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.46.3.tar.gz"
  sha256 "73f09918ba4ba28c8a42053a2d1aab1f29e821aaf2d3d08088010a2b70ffb329"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b2c4d8b00c1fc0d351ae4c31dfe1097adaf4b0c7b4358ca8bf2ddcfbb634345"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b2c4d8b00c1fc0d351ae4c31dfe1097adaf4b0c7b4358ca8bf2ddcfbb634345"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b2c4d8b00c1fc0d351ae4c31dfe1097adaf4b0c7b4358ca8bf2ddcfbb634345"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab8d3e94f40d5ec31926a9ca846b03297f3a48bb1f255647b6f728ddf534f244"
    sha256 cellar: :any_skip_relocation, ventura:       "ab8d3e94f40d5ec31926a9ca846b03297f3a48bb1f255647b6f728ddf534f244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dbbcff2e75c5149bddb855e913949c3aee5fc02243e6f026a68711277a0f6d3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
