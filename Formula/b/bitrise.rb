class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.42.1.tar.gz"
  sha256 "ebd05c7acec7d6b6eb1dcdc8d80b91e87d44fe5b89451208ce431a78408aa16a"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f42e6ff7580f6ba4762e88c021e002b0b2b214f7ef0098074c29a11e4cc70c8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f42e6ff7580f6ba4762e88c021e002b0b2b214f7ef0098074c29a11e4cc70c8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f42e6ff7580f6ba4762e88c021e002b0b2b214f7ef0098074c29a11e4cc70c8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8041177e8f9f39e77bb2d11d39ebc5dbd0da75a7ad9742715ce2844efbbadff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce8acf9a751464bf962203e0f9f6da1461be964e26ddf11b91a8c86655d42ba9"
    sha256 cellar: :any,                 x86_64_linux:  "9ef862cecc515a1be4a773668a29af675fb1d6d83167fabb00b6c5a38fa2aea8"
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
