class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.36.2.tar.gz"
  sha256 "d30022e3136533b7cc7933dc252ed3967085b3d3924c16c41d95947b062dc046"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a44504e99f8b337b8d7de3cd506c3ecbb9357f40a8c154a52ae3be4956254d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a44504e99f8b337b8d7de3cd506c3ecbb9357f40a8c154a52ae3be4956254d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a44504e99f8b337b8d7de3cd506c3ecbb9357f40a8c154a52ae3be4956254d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c85ece14c1e384dc9056d661f978c94d0f7bfa788846de23cb39523125738218"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7be36852fdb72dcfdb4ae7512ddb27f6eb44692e25777c68b38c90cb1dfe3770"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37cc71ed68531ed825a569683db9386d0f287b155b5697a017b7fbb793ad139c"
  end

  depends_on "go" => [:build, :test]

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/version.VERSION=#{version}
      -X github.com/bitrise-io/bitrise/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
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
