class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.13.4.tar.gz"
  sha256 "101e3d27f6449d072826878edb9d8f852848bbc7f9694b5966007bc968de6872"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e1588f17d4359bed8c9a9b84230518262cb123ccc26f4da93ea6a9c6aa6cff1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eae160db703a72e7988dc85876f5e49ca241d263de881c9b02ca323546d5811"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1d5b76494a4f4f6d1933463f9807cd1f40dfc8484abcb80563d5875c95e2eb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f13b8413b9a48ac0ffdb2f8bc47726ef8fc3abcbe9aa458bf767913d724615a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0cffeb5b7215c2d0714699e3928c36057c6224b775fb3d4dc9123720e7faca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5aa0da33b796c190273c7a219bf7602f76c52586df78847af9606fe653c6b306"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end
