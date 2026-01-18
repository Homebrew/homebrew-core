class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.6.3.tar.gz"
  sha256 "8baf148df075575372a583afc6af17926c2bcf8cf5dbe8022aaeeeb6490ecda4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbe6e89f6156242aab4ed8124c2e6dd84875f7e38a79f79c088b12e21f451464"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbe6e89f6156242aab4ed8124c2e6dd84875f7e38a79f79c088b12e21f451464"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbe6e89f6156242aab4ed8124c2e6dd84875f7e38a79f79c088b12e21f451464"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cb20a34f444c1db8f2d4e84ea5cff92c9fc19bd036582b1ba7473166fd9d3eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84004622939dabb006057557a48c02e4701add22f22f1510a528bc4c15b63150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79d68c5692a4d9e80ce7f1e23328d2e0909c62e065d18bee4ff8680deea6922c"
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
