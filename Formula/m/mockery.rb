class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "28b1ffffa916c76a045ae9f7b7684883962319a48ffd7eecc300cb714128e124"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62217e0839b20c5c6875df6a2a66189729238a44b776c54816054637b4bee46e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62217e0839b20c5c6875df6a2a66189729238a44b776c54816054637b4bee46e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62217e0839b20c5c6875df6a2a66189729238a44b776c54816054637b4bee46e"
    sha256 cellar: :any_skip_relocation, sonoma:        "07e702aae0ee975c93e5d88b4c4ad0fa8eb253aa49e03f89e074b41da0848e93"
    sha256 cellar: :any_skip_relocation, ventura:       "07e702aae0ee975c93e5d88b4c4ad0fa8eb253aa49e03f89e074b41da0848e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cf33626da7b4199c456b8fea868884581cf2bbd5034f8918b16d632e623f234"
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
