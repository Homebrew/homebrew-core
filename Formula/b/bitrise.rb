class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/2.27.0.tar.gz"
  sha256 "2dd64874e60208602b5b78c4bd521926dc476766965cb46d5dc0fbd00ecd0ce9"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "022489c4fe24310f56ea72aa470c618c6483a885fd793c8080cd0ca8e6cf9557"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "022489c4fe24310f56ea72aa470c618c6483a885fd793c8080cd0ca8e6cf9557"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "022489c4fe24310f56ea72aa470c618c6483a885fd793c8080cd0ca8e6cf9557"
    sha256 cellar: :any_skip_relocation, sonoma:        "d96bcc72f684bc132a119683197eb2a30a11fe7f9a363f63358a97992431bd8f"
    sha256 cellar: :any_skip_relocation, ventura:       "d96bcc72f684bc132a119683197eb2a30a11fe7f9a363f63358a97992431bd8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ef741a7c31117cdd9e205292c2a6c7fb1e252e20246d47c672aadf8e8e46c2e"
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
