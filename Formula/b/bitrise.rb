class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.34.7.tar.gz"
  sha256 "c6e44b16307e2e3e1595d39372fc9b921acf8803f86153d3acab2f5c478fd0eb"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4985ee39a2471fe5b19fed2de9ea18de9fa7724d0fea58cd5c1d605abb92484f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4985ee39a2471fe5b19fed2de9ea18de9fa7724d0fea58cd5c1d605abb92484f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4985ee39a2471fe5b19fed2de9ea18de9fa7724d0fea58cd5c1d605abb92484f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a216cba49a7a8f8d296b8dba271fc219d9eaa6970ff0be9e61628a111987bbf8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ab292a80933bbe2c48a88814f1ebe5a08ae59c9f7c35a4082464ffc3aeea806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70d1c0c1aa65b9f60108e906b1585e0f443aef3b4649c7b1ac4e671b409bad50"
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
