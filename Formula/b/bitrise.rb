class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.41.0.tar.gz"
  sha256 "f84ce9429c83358ddced9700bde3e59dca58bf0144ea719aa4101814133a22ca"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "925006556f338abcb25d2cacf2e6296c79e485c17c559fcf9bced278dbb9985c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "925006556f338abcb25d2cacf2e6296c79e485c17c559fcf9bced278dbb9985c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "925006556f338abcb25d2cacf2e6296c79e485c17c559fcf9bced278dbb9985c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e4f4a4f71d7cb72a1933fb0f7ba7ffc3345d396c49d6f79bf9083f02a438987"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "088f60962f69f8ac4268178a7ab6bd1fe4d2f8f083d44ed3e174e1f365a83e23"
    sha256 cellar: :any,                 x86_64_linux:  "ff25213a47cb832685012196b8989d0e3a35de2417d93f1bf07055200c38d29c"
  end

  depends_on "go" => [:build, :test]

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/v#{version.major}/version.VERSION=#{version}
      -X github.com/bitrise-io/bitrise/v#{version.major}/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bitrise --version")

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
