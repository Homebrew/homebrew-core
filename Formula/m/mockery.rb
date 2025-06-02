class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "479b93d6699b3d62141c3629330af52733545d0040d0c3b8cb594fd5a3e8f576"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "361d7f3c0ce58843da4f350a95ff9072ec9c38f9932ecb6b04731408cc79aa92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "361d7f3c0ce58843da4f350a95ff9072ec9c38f9932ecb6b04731408cc79aa92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "361d7f3c0ce58843da4f350a95ff9072ec9c38f9932ecb6b04731408cc79aa92"
    sha256 cellar: :any_skip_relocation, sonoma:        "99fae277c160e113ad6b1266d62b5672eb5fb770a72d7f10e69af9aae7ada807"
    sha256 cellar: :any_skip_relocation, ventura:       "99fae277c160e113ad6b1266d62b5672eb5fb770a72d7f10e69af9aae7ada807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db932a7be8eba2001bf410daec745a1f26fb30f4c21ec56a36c13e1dcf4d4eb0"
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
