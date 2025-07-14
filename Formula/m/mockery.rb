class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "02586a2dcd30de1ab48106224cfbba4306f7d16e9e552bb5202c57c24610e5c8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a291387bf9f3ec3fb1947f08e1cd686ae36502d226220ed513248aea6766fafd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a291387bf9f3ec3fb1947f08e1cd686ae36502d226220ed513248aea6766fafd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a291387bf9f3ec3fb1947f08e1cd686ae36502d226220ed513248aea6766fafd"
    sha256 cellar: :any_skip_relocation, sonoma:        "94bb183ece74ea3040bca9fe64e166901cd0bc10356fd787e47f664406ac8755"
    sha256 cellar: :any_skip_relocation, ventura:       "94bb183ece74ea3040bca9fe64e166901cd0bc10356fd787e47f664406ac8755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "914def2eb5ad6dda1ff9d93ba5134f3791e59e9cd4ae63ab6a37fc72af640e5a"
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
