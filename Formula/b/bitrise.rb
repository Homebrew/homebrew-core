class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.31.0.tar.gz"
  sha256 "a3805ca8fe04a3ce835d0641c3c51ca477bc594696e8ee842dbb8f272ebcd0e8"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50018beb0b340d49f8d849f8d75cb0ed99054da3e3a1894fbf88567257ffaf20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50018beb0b340d49f8d849f8d75cb0ed99054da3e3a1894fbf88567257ffaf20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50018beb0b340d49f8d849f8d75cb0ed99054da3e3a1894fbf88567257ffaf20"
    sha256 cellar: :any_skip_relocation, sonoma:        "a17f73328a63f46f889662ddbe1cfa1593fd7df769b3948443ef6e45f1c0c218"
    sha256 cellar: :any_skip_relocation, ventura:       "a17f73328a63f46f889662ddbe1cfa1593fd7df769b3948443ef6e45f1c0c218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c83368471caae826e83dad80585d481a664a7504466c17c93cb5a750a3820de7"
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
