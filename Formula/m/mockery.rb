class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "bd82f58e9c17d84e9c933a89375c6a18c4d79909032f22885e4504c519f4a60d"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "v3"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0522ad647f950503e681bd1b7bb28d146531c7361d8283531134821a72f75ba4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0522ad647f950503e681bd1b7bb28d146531c7361d8283531134821a72f75ba4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0522ad647f950503e681bd1b7bb28d146531c7361d8283531134821a72f75ba4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a4c20f007d007f8a1697eced63c5a71735b63ada6cccbc0e62d586cca22fba6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31dc800bfe67ad81dbc4d743dca84449c59630f9a9f83d2be07ad0fd95d5c030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c66c8d9dc1db5fcf9c78783c2e23a81f3f09c4620ddd5901ece216b7cc69a71"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v#{version.major}/internal/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mockery", shell_parameter_format: :cobra)
  end

  test do
    (testpath/".mockery.yaml").write <<~YAML
      packages:
        github.com/vektra/mockery/v2/pkg:
          interfaces:
            TypesPackage:
    YAML
    output = shell_output("#{bin}/mockery 2>&1", 1)
    assert_match "Starting mockery", output
    assert_match "version=v#{version}", output
  end
end
