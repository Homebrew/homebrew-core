class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.43.3.tar.gz"
  sha256 "e58c06dea561b206f4bc0e7677a6e1d8baed6997765c3542f22dc73fbcfb8dd5"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c068a55b44f9fa7bdf4b9ac206eba07fb4ebc2d2ba9e9ee2878e6e4079e5fcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c068a55b44f9fa7bdf4b9ac206eba07fb4ebc2d2ba9e9ee2878e6e4079e5fcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c068a55b44f9fa7bdf4b9ac206eba07fb4ebc2d2ba9e9ee2878e6e4079e5fcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac28e8060a679bca7b1967afc57ab50185bc860648fc086d6d41176053319ef9"
    sha256 cellar: :any,                 x86_64_linux:  "b105a12fce957f6d9d428bb8d0a8fac44ba914afa822ae0d03cc96280e6eb17f"
  end

  depends_on "go" => [:build, :test]

  uses_from_macos "rsync"

  def install
    ldflags = %W[
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
