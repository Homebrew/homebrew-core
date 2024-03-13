class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.42.1.tar.gz"
  sha256 "3f1a62c24f4fa39d0637e48819e73c7dec8956b6bed4c66e1e03e8e453284bf2"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62dc8c9d83dd70d673052e53d48f2cc47829e3c923f9a812c89f18586708f213"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cef6b0359336a07623350735829e3d4da8054951c11024676a9d1a55a3b942b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1006cca90de7c579eae984c01431222446cd73168c41e488e882dfcb331df6b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5e7675a4aced8d78e78f4d8f152948b27fac97ded38b148ad38cd5d07f5b2b3"
    sha256 cellar: :any_skip_relocation, ventura:        "d0ec25e005f6b151f3f0470450c0f7fb84c6c23e8c67960cfdd2eb53b5970364"
    sha256 cellar: :any_skip_relocation, monterey:       "fa519d02f2b6e697857c6463bdb9f78cf626daf97b3c81d5cc6f8437b993acec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec6491c3dde5b49398425663c2e0f550fd1d7a4491761462916e6adb47b45fd0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
