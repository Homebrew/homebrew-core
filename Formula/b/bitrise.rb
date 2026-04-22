class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.39.3.tar.gz"
  sha256 "f3e9e5c1edb19769af58e4931df4eeb90b175f13d54ddf9728abd6ef2edc15ba"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a81e42009ae2a36b797226af4f6d6f0529408e948c04658273383e07e891008"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a81e42009ae2a36b797226af4f6d6f0529408e948c04658273383e07e891008"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a81e42009ae2a36b797226af4f6d6f0529408e948c04658273383e07e891008"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ce1e5e25c8b721c23d1df6b2d0deb83ce163dd45196e5e7aa2f152bef20fe01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c75064a87ea024393fadf67c09c94a48ace30c8f41a38d015feaf918f2bc187"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a80f5cccecd7a6af39d257c9b921bfadca64ab176e313379b09b8a3700182385"
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
