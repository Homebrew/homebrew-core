class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "7a6f1a99626cd4471353d6726e48980911763dfce67a04131235ca586e75b579"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57b5888518af3514ad124f576e327f8961dacac05e09ff4a4e5932d95e97fb54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57b5888518af3514ad124f576e327f8961dacac05e09ff4a4e5932d95e97fb54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57b5888518af3514ad124f576e327f8961dacac05e09ff4a4e5932d95e97fb54"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c06213f493feca3cb38fe8fda74dc09d83afd971c540d599fc87c1c99fca623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f72980b1c090c38a693b2113d24e1f210b142e5aa774eba2c15db43fffab3d6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05199f77f9e5092090ba938fe48309b0dadb21bda29965a909efa03c90a8163f"
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
