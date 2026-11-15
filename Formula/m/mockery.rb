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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b52772f24c326d38bfb532e7ef3502f8e7d588f42c30ccca519c5a0bae804d88"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b52772f24c326d38bfb532e7ef3502f8e7d588f42c30ccca519c5a0bae804d88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b52772f24c326d38bfb532e7ef3502f8e7d588f42c30ccca519c5a0bae804d88"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "588c8bd29e95c81dd49dded0cfec417e145dbf2921d1bfb5d1bd60d5fb6baf00"
    sha256 cellar: :any,                 x86_64_linux:      "3f38d757f7789f144cf4724964c1f7702f01b53d2c45e1391359ba251f814c90"
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
