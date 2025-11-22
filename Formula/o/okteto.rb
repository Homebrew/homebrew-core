class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.13.3.tar.gz"
  sha256 "2dfe15d5d46f2952884f52a3cbff3fe0367b62dd8269b024b8b4428fc66b5d05"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54797b6cd8e475e480c42b89c27c9033cc56728ecc0040a606bc4189535317a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a35b0bbd07e0db7a091725d31f5d447c38977bffa13ce44d0b47d2b10c989df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cccc16647677944be14f6af6ac700b39c9179af6b8302ef1bf147217ddcb061"
    sha256 cellar: :any_skip_relocation, sonoma:        "16f361fc0efc8e8ce96d2a2b5b6868d47103e3fa1d1a5a03266da78caecfe768"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e11b6902d0e8bb9b8281d3bdba45272d4e425fd629da199cc9000b10acad8813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7484a78dd1f38d8e3c1485c933c54ca2cd345432d30052636217e101374b3602"
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
