class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.19.0.tar.gz"
  sha256 "3bb13c8740112262bfb006ff02435b0d3c7b52d47c5c49788e05b2844fa27fc0"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd87479bf5e5a5acf0a165df44d477a8184bc0a467f21c6aaeb0a09f76b827cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c352580e4fcd64ec7cb064b6706c7613e8a240310607736a5d5284e66c04b0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "309eb983144a7d52edf7e4a80d45dba7dd578bde0949eb7c1f805742cffdfdd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c732f0eae575ca5aeac86d0a8335a63c28f93f86627cb28f36734ce48e0b907"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dbd8117d9e96366ac485d601758cd348691e6fcaaf2cbe38af053c9e29d8893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9752317ad60b60e648a6b4d66905c3e7e261454dc7377b47218463ef73338bfe"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"okteto", shell_parameter_format: :cobra)
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end
