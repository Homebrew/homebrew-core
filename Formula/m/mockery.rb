class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.5.5.tar.gz"
  sha256 "ece14262f8aa0a7075c9c03034002026d815beeb0b62235c5ae9375e3bb47e60"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57c54a0c6363e248ef3273ec97a299d5b27bdac86cdbf915ca68768278695792"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57c54a0c6363e248ef3273ec97a299d5b27bdac86cdbf915ca68768278695792"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57c54a0c6363e248ef3273ec97a299d5b27bdac86cdbf915ca68768278695792"
    sha256 cellar: :any_skip_relocation, sonoma:        "477dcffccdcced8adb32e866c5f0362cfa668e72387d99356e837eb42b5b1bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddd52e55c94618d2854a116437b8e348a44146d12155eb8f22e1887e725ee823"
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
