class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://vektra.github.io/mockery/"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.8.1.tar.gz"
  sha256 "6db3558b8c9f70b23458696b856d2207dcd7c0a48d02192ebcb10ee2e03924e4"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7590d89c01326be5876a2b7b94ac67e6350c4494ea977aa80a16175b1496fb46"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7590d89c01326be5876a2b7b94ac67e6350c4494ea977aa80a16175b1496fb46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7590d89c01326be5876a2b7b94ac67e6350c4494ea977aa80a16175b1496fb46"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a3ef9d534733e9b18f4c6f04085c8d1ed577c2d1ab942a4a006e90193f78e8d3"
    sha256 cellar: :any,                 x86_64_linux:      "b136f6a8a81f51a09661c5d1816354d24b9f2c6a91f4d536dcd14aaa63d35cd1"
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
