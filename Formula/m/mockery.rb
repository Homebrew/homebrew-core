class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://vektra.github.io/mockery/"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.9.2.tar.gz"
  sha256 "99be2b46da10d1486e1a8860bf184a4098231b1e16894fb447b89ab61f236452"
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
    manifest_sha256 "bd3739b184c5b572bc75677d64581b2e8aad82cd5dae53e31efa5501319745a7"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "566e8a24e0e7eff784bb6b17ff5b64c904ad298702e991cb13f54c3c5609b2b7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "566e8a24e0e7eff784bb6b17ff5b64c904ad298702e991cb13f54c3c5609b2b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "566e8a24e0e7eff784bb6b17ff5b64c904ad298702e991cb13f54c3c5609b2b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "516a8cc9fc06d7f55430ad40c6b5efc87ff7e4f4e45fc31733098885605dad32"
    sha256 cellar: :any,                 x86_64_linux:      "0f188cb1646cb7f58e4e154091e7f809b3ebf00fab370bba9d2bb5e0c14abf31"
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
