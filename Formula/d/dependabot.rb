class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.91.0.tar.gz"
  sha256 "79b9dd669d39390fe8ea4c8376822774534f0234cffbe7db85bc28aebd23312b"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1cc01d9cc5b2dbda065134cbd0bf515c8bdc23a32b3522107fece934154dc14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1cc01d9cc5b2dbda065134cbd0bf515c8bdc23a32b3522107fece934154dc14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1cc01d9cc5b2dbda065134cbd0bf515c8bdc23a32b3522107fece934154dc14"
    sha256 cellar: :any_skip_relocation, sonoma:        "056656e48d7c8440e26c30e30f74e86b8fcb0e9a4ea2783186b3421da121145f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37f34148d279fd6b81b00021042265c49de88e49d807f6a934b59b3ca34b0f0d"
    sha256 cellar: :any,                 x86_64_linux:  "c078f6eef9f0c1516552f71c5b066a965466f62bf7b81ebbfbf2d1860e3f5475"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dependabot"

    generate_completions_from_executable(bin/"dependabot", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    assert_match("dependabot version #{version}", shell_output("#{bin}/dependabot --version"))
    output = shell_output("#{bin}/dependabot update bundler Homebrew/homebrew 2>&1", 1)
    assert_match("Cannot connect to the Docker daemon", output)
  end
end
