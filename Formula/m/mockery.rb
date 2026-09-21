class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://vektra.github.io/mockery/"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "166487e34348d95057252e5a1a172d272f12eb01902c0c05c2a948567028800f"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "78c117a04960f4bd026ca890067e23487f7fcc9d0ed5fd3563be0ec362bcd6cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "78c117a04960f4bd026ca890067e23487f7fcc9d0ed5fd3563be0ec362bcd6cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "78c117a04960f4bd026ca890067e23487f7fcc9d0ed5fd3563be0ec362bcd6cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "78c117a04960f4bd026ca890067e23487f7fcc9d0ed5fd3563be0ec362bcd6cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1e3e0513a0207d11bc1e01afe0f35203b7137a49d3252115075785a9e00db70f"
    sha256 cellar: :any,                 x86_64_linux:      "29711a8708a8e70b0bdac1ee4d564ed64bdd47df59a0e65fd1b793a36cf4d2a9"
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
