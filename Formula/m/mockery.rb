class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://vektra.github.io/mockery/"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.7.4.tar.gz"
  sha256 "516ebae7641e373ce3d7d00fe1ab3df616baffd345f097081d0a4b0d1e3c21e8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d6a1c1a526dedb51c6c95e057d815497bf7e6b148b2d34c6d36288155e95561"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d6a1c1a526dedb51c6c95e057d815497bf7e6b148b2d34c6d36288155e95561"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d6a1c1a526dedb51c6c95e057d815497bf7e6b148b2d34c6d36288155e95561"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bdbcece0b83f256bdb16f0c4f681a3facd2de3c6111e96c53bd76d929193ace"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9beac378d485437c96b5e2a9114786b26cc3ab41d4f1cbeef068d71e13187a58"
    sha256 cellar: :any,                 x86_64_linux:  "cd1ca1f563f1fedd244fa9268f2f41d5ad7406ac8eb8f5a917d2d34e8e14a281"
  end

  depends_on "go" => :build

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
