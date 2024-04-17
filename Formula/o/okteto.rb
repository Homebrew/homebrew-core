class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/2.26.0.tar.gz"
  sha256 "2015386aa186f948a4e2025576dc63695a336c70149db2b940431e943fb7f63b"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "248f94620e9e75b5473d21e32a85fae09747313b624ece1dd00f3f449acfd21e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebd75623e64fe85f1d84c884cf868c122eacb21c5ab984832dc32ed5c39ae5a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d75e1dd43fe954968d93cb0885e00493cbd418eb0c573c95d7762a4abf69717c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9dc187dddf00c4caee72ccef9139b2d482ddb9f5f9f450eabd2df904e802b75"
    sha256 cellar: :any_skip_relocation, ventura:        "44c97c68075ddd15ea8c8a1e30812ba8712dd15981e815959ecf0e1272fd49ae"
    sha256 cellar: :any_skip_relocation, monterey:       "35adf2cefd445c9f4ec2ebe83266c413cac50046d153d21e350d840881a53e59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f89014fd5b1da9613fe246e1d82299e0d412a2f74a4bbb11b8e643cd64e9e3eb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:), "-tags", tags

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
