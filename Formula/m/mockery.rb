class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.2.3.tar.gz"
  sha256 "1f1388f04ccb21dfe25406662e8398d8416870a04ca92528ac931fc1822901a9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c54354876e336b3fa3132d84d7e846c5bfd47c21b7161d6c2b212f40899ef828"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c54354876e336b3fa3132d84d7e846c5bfd47c21b7161d6c2b212f40899ef828"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c54354876e336b3fa3132d84d7e846c5bfd47c21b7161d6c2b212f40899ef828"
    sha256 cellar: :any_skip_relocation, sonoma:        "31fa94e9fdb106c37c6e9fc2f171e405e699d053b2354e8a98af7dc0f6b61b41"
    sha256 cellar: :any_skip_relocation, ventura:       "31fa94e9fdb106c37c6e9fc2f171e405e699d053b2354e8a98af7dc0f6b61b41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c4a49702683b3c405f82c482e22b5c6df29d7afaa82483d534186789672d1ec"
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
