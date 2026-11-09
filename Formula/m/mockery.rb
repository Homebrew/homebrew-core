class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://vektra.github.io/mockery/"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.9.1.tar.gz"
  sha256 "c73f648fac846b84cca2db017255faa4fd363f72a7a748f281e55d07ed6b3372"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f5df492e56e3bb5fd071e00795903c56e6d2e6d27eb458612e57270d1dd67dd6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f5df492e56e3bb5fd071e00795903c56e6d2e6d27eb458612e57270d1dd67dd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f5df492e56e3bb5fd071e00795903c56e6d2e6d27eb458612e57270d1dd67dd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7f9c38223e12f03c645dfb6a88bb8b42c96107400dfdeff2f155ea4e0001ef9d"
    sha256 cellar: :any,                 x86_64_linux:      "d772433b8c69905eb0742171e30658e4eb898e6c26497dabb7bd7cd8c66474cd"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/vektra/mockery/v#{version.major}/internal/logging.SemVer=v#{version}"
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
