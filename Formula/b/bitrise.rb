class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.31.3.tar.gz"
  sha256 "bf97c16707897cab16b14719ed0fab6243925d2e66bf1a1878f1f12e16b30868"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "188092ac74ea977c22f2084cb737566003a32c307e7782917ba7bf9f19b4bd35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "188092ac74ea977c22f2084cb737566003a32c307e7782917ba7bf9f19b4bd35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "188092ac74ea977c22f2084cb737566003a32c307e7782917ba7bf9f19b4bd35"
    sha256 cellar: :any_skip_relocation, sonoma:        "d406cd3b043183711750089ed2c17657197c43f976f4a1314c1015b833406129"
    sha256 cellar: :any_skip_relocation, ventura:       "d406cd3b043183711750089ed2c17657197c43f976f4a1314c1015b833406129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ead533648fba8e4d7844aea2791e7629078f5749adf294f2bb6c8bb99ab8f636"
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
