class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "d7b01b1b2d292eb90d492fc3bf2ad3924fdf7f92d23b4c8b16c5645849902280"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bd045dbc583a130717f567ee68b16a862ebc9abfcaa76865e81f82cb7384d47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bd045dbc583a130717f567ee68b16a862ebc9abfcaa76865e81f82cb7384d47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bd045dbc583a130717f567ee68b16a862ebc9abfcaa76865e81f82cb7384d47"
    sha256 cellar: :any_skip_relocation, sonoma:        "429cf65270e4fc97b347ce496d81b49b22de3c4299db0174427ce6af5a819b09"
    sha256 cellar: :any_skip_relocation, ventura:       "429cf65270e4fc97b347ce496d81b49b22de3c4299db0174427ce6af5a819b09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac4dfa4c3ed2cea6c19b15875f437602fee1250b8c2b00f252c0641962ada546"
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
