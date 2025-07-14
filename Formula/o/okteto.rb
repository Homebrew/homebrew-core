class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.9.0.tar.gz"
  sha256 "b8baa40cb4dea271dd146a31a9b0fdedc40bc74b6f89521fdace48585da3e687"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3fc421977d94e90bb68fbce70aa98224b2ccf9d90441a7c1a3a871b78d6709d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7cdedc2ab092f5181e20ee5ce303cf6420fe0ff363b31d08c05ff6294f2390b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b6aac413ff88e216d9dbfc255f5b4e986998a8e91377dfd7887d5f97dee231e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9eb516c7135cc3f833f9c9fc82bafef0aafb906ac7b499e66e36229eb85a768"
    sha256 cellar: :any_skip_relocation, ventura:       "b7eab5198d2d357470e67a0fdd1c7f7d28239e6e4e1d7fcb0604f8e7ad5ebd4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "557969459fc2af5591364ad8d6be65a6ea55dd5548d2ec531cca18d4e46887bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cd709f947f53cd618f67578ac8267a9a242fbcfa577ae5644cbe335be8a3f11"
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
