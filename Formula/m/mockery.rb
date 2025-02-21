class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.52.3.tar.gz"
  sha256 "8677c487e91752928f60aa49ccdd08d12f95d45b99815595d7fe0372675c8711"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29024b7e77ae9eb3f09e2ad148ca62d50b3ac35cc3bea98cb0981c3f895a8a22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29024b7e77ae9eb3f09e2ad148ca62d50b3ac35cc3bea98cb0981c3f895a8a22"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29024b7e77ae9eb3f09e2ad148ca62d50b3ac35cc3bea98cb0981c3f895a8a22"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dc3603463d410b95ab7e1b13a062196226c75fd1bb5252b90bf4c6b5b54be27"
    sha256 cellar: :any_skip_relocation, ventura:       "5dc3603463d410b95ab7e1b13a062196226c75fd1bb5252b90bf4c6b5b54be27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4f1bd002e09053637331151784193c28df71659bf5c4f8f188f35fec1b9d7c2"
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
