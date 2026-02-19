class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.6.4.tar.gz"
  sha256 "c06d6c6c2570a269fa95c24af0b15da8a9cb69de21ca0a2965d1d16b40f9bb08"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d86797df7b536d476a6c3a2797e6a026b97539e1c1420c76ca9071bc8e8b0af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d86797df7b536d476a6c3a2797e6a026b97539e1c1420c76ca9071bc8e8b0af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d86797df7b536d476a6c3a2797e6a026b97539e1c1420c76ca9071bc8e8b0af"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8d50e46201f5f85282276bb1d1f0c7d7dc39b0e756230daa5a2ce284d5608d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cab8e75e3e824d07b4d825e0ab15f69a698841d2eaaaf385d6732d4d5e2de5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e030ecdfffc61c9f03c505572a2a4d3830fe217d7725579fff1910bec696962"
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
