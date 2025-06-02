class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.66.0.tar.gz"
  sha256 "af61aba6b327d411275fd18af758862da82287abe260562ec7c7fb90c10bf852"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7254ff551fe7686cc6a34ba78bc17239b80ceb847ae1c3b9655f09a8965e6fe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7254ff551fe7686cc6a34ba78bc17239b80ceb847ae1c3b9655f09a8965e6fe4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7254ff551fe7686cc6a34ba78bc17239b80ceb847ae1c3b9655f09a8965e6fe4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d81c0f34f3c546b12c2ce4ad0228c2f034982a13eb4d0380959219cc2e1675dd"
    sha256 cellar: :any_skip_relocation, ventura:       "d81c0f34f3c546b12c2ce4ad0228c2f034982a13eb4d0380959219cc2e1675dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5f93ebe400c770385709bd6e3819f4c4f16d4d6f7d21800f12f4b1c5a81ac1c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dependabot"

    generate_completions_from_executable(bin/"dependabot", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    assert_match("dependabot version #{version}", shell_output("#{bin}/dependabot --version"))
    output = shell_output("#{bin}/dependabot update bundler Homebrew/homebrew 2>&1", 1)
    assert_match("Cannot connect to the Docker daemon", output)
  end
end
