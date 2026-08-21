class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://vektra.github.io/mockery/"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.7.3.tar.gz"
  sha256 "16b9b8ec31e1a055a9ccd2b19fe0c635d182b202fcd5c4980f384d79bfa48201"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c439243737eb37058c4622a4c47af82b51384cb90ec75b09e23aede639769bdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c439243737eb37058c4622a4c47af82b51384cb90ec75b09e23aede639769bdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c439243737eb37058c4622a4c47af82b51384cb90ec75b09e23aede639769bdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "eff106807494d817e21dac5cb613c5b4799b4071428164fcf8ba5a71a81d9734"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeef37ee5900b280b6069c5ed9c2ad747a32f9f0c5840872799da7180f26f884"
    sha256 cellar: :any,                 x86_64_linux:  "2f5e842074e401cc76c6ac12af1ea19726e8bf16713c3bae5b1c9a0ae23fc53b"
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
