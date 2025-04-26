class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.62.2.tar.gz"
  sha256 "bf350da9f1bf3dec4073ff80da72bfaa6d401f38dbe72bf1beff76fca200524f"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eeb5548ae78771de3c53106f5a6c6386179fbbc156c54beb83298d3e46495ad3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eeb5548ae78771de3c53106f5a6c6386179fbbc156c54beb83298d3e46495ad3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eeb5548ae78771de3c53106f5a6c6386179fbbc156c54beb83298d3e46495ad3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6185f7cfaaa886ac22768fb510e323e9425d39c5d5e87ff0e932c7944c0dafc2"
    sha256 cellar: :any_skip_relocation, ventura:       "6185f7cfaaa886ac22768fb510e323e9425d39c5d5e87ff0e932c7944c0dafc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99882a1079b384305faf3fe4ebc498e8db03f1c72427d82d71254d2ef5149de0"
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
