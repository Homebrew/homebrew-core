class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/2.25.2.tar.gz"
  sha256 "b212652b0350edc16ed525129a0532cc64adc75600fe6cb3bce4dccf509d790e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f3145d832bbaee63e591bbc67c927a2ede9036f35ef3d3c59f1f7bb565ccb1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f3145d832bbaee63e591bbc67c927a2ede9036f35ef3d3c59f1f7bb565ccb1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f3145d832bbaee63e591bbc67c927a2ede9036f35ef3d3c59f1f7bb565ccb1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9cb230df102487836fdf024f945da0b7e75a3ab2bfa8c579d3a9f26164fd454"
    sha256 cellar: :any_skip_relocation, ventura:       "b9cb230df102487836fdf024f945da0b7e75a3ab2bfa8c579d3a9f26164fd454"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6b95bc86ec03a09d639891e7bb431be878c0706651a9e2380be357770484d1c"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/version.VERSION=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
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
