class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.2.5.tar.gz"
  sha256 "e3f21fbe91e662b7375588b2ea08f710afaafa594e9383dbe8879a0787806138"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c26da80872583720b599e42bd62a7149fd06c72e8818a938205d90beb525144"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c26da80872583720b599e42bd62a7149fd06c72e8818a938205d90beb525144"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c26da80872583720b599e42bd62a7149fd06c72e8818a938205d90beb525144"
    sha256 cellar: :any_skip_relocation, sonoma:        "6686824820921b0a6bb7f6d2544eae85014c1ec1be1c36dcd8aa341a60810095"
    sha256 cellar: :any_skip_relocation, ventura:       "6686824820921b0a6bb7f6d2544eae85014c1ec1be1c36dcd8aa341a60810095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a5a4dd38d7a705bdb0a13a881b1591e058ae059d5366f5c93a78eb01b4a1ba8"
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
