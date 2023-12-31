class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/2.23.2.tar.gz"
  sha256 "961f686acf8df02895bb150965114a2f5d189e6319fa01a5fe1a699d2d5f35dc"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b3a08f33d6c5bcea13998e9f72461853b03da93e85f20fcf2f4c854424b8efc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abf44e0d4c10427b59b9f5f7a8efc52a0d692404de5d5edf15dcaacf88a53df2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "451a58cc881c44afb58f2ecb05f6cd51d35f6de5f5b0fd41a9951fc71c7a4c97"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec5d5d1217b15add6c245bd8c67bd273753b5bc9aac83a4f5aa437ef536e53e7"
    sha256 cellar: :any_skip_relocation, ventura:        "63fcfdf01267f98a55a373dac5a63274f9f6871b9a0bd8754d6bc06b4ac1fc7e"
    sha256 cellar: :any_skip_relocation, monterey:       "987e0f59ae9cd627c48afce7c1657b09dcbfa7ad1f0d532fe6cf10345d988bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68f311f3bed8e80d7e2d1bd49413c64275caec7b9a4b818506e92e86f7f23d8b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
