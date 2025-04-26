class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.2.4.tar.gz"
  sha256 "2215833562260b00e2a6ee9b2a610ced74e6be8fc9bad737a9581f4f22fa50be"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e857f4d6bd894ce2143afb351f2f869787bfe3c69285c3fb88d21b217844d77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e857f4d6bd894ce2143afb351f2f869787bfe3c69285c3fb88d21b217844d77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e857f4d6bd894ce2143afb351f2f869787bfe3c69285c3fb88d21b217844d77"
    sha256 cellar: :any_skip_relocation, sonoma:        "e32eddb7ee10f56b973dc745734d1019a8819ea9cd9251e87f4b78eb3645415f"
    sha256 cellar: :any_skip_relocation, ventura:       "e32eddb7ee10f56b973dc745734d1019a8819ea9cd9251e87f4b78eb3645415f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "165a89dc2ea4ad432176924df80aecb2ad8e5f4d284991ceb8a21b987dd51299"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v#{version.major}/internal/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mockery", "completion")
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
