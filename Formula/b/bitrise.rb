class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.30.6.tar.gz"
  sha256 "efcbe17a7e8e2e6041295e3168a1dce8e3ddf3fd012fae7934a67138be44c808"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afb459fb179d16fe2ce6327f4dde506ab1a0c2cf8e3b445d95ef121fa443632d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afb459fb179d16fe2ce6327f4dde506ab1a0c2cf8e3b445d95ef121fa443632d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "afb459fb179d16fe2ce6327f4dde506ab1a0c2cf8e3b445d95ef121fa443632d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b310e110c1a8b6f7d12677aefd0a1c1afdbd4dbccab5f8f6cf2d09acdb6e6480"
    sha256 cellar: :any_skip_relocation, ventura:       "b310e110c1a8b6f7d12677aefd0a1c1afdbd4dbccab5f8f6cf2d09acdb6e6480"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b752ac19b893567589abc669780b132490edee39878118f87d677872118019a"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/version.VERSION=#{version}
      -X github.com/bitrise-io/bitrise/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"bitrise.yml").write <<~YAML
      format_version: 1.3.1
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    YAML

    system bin/"bitrise", "setup"
    system bin/"bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
