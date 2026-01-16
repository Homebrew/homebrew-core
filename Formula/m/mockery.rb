class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.6.2.tar.gz"
  sha256 "9a02920a4f97cbf2b6e673ccbb3234f7b5683e0ee8c9340cb14fefd0e9e7f505"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0a010a67b83d018311f9fe7c16b9e1bfa8da96e0adc8020ab1aa2b1ef94a180"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0a010a67b83d018311f9fe7c16b9e1bfa8da96e0adc8020ab1aa2b1ef94a180"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0a010a67b83d018311f9fe7c16b9e1bfa8da96e0adc8020ab1aa2b1ef94a180"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d992ad6d2a9a1037b84e73ff2eb1c97353f9ef53524efb3b204de5882543560"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ed6c5ca4f2e7642bc111ddfcbb719818c41c5104b4472f59a1f788452c20d2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0454360d7dcc197d309aff84ece49e22a30462c6f8531b8e4bd106663ac461cc"
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
