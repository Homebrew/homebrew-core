class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.57.0.tar.gz"
  sha256 "71cf1048899dd050134dc5ac817ec5f86852de8396fd367b63a51f8577ab8178"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8aa7def2aa38f70ee9c5a7b9bc9415bdbd36a334396d451824d61158119e85fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8aa7def2aa38f70ee9c5a7b9bc9415bdbd36a334396d451824d61158119e85fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8aa7def2aa38f70ee9c5a7b9bc9415bdbd36a334396d451824d61158119e85fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ff554ec563b70b7d3e50837b6ef36fde6024839638212cf061e5f683a10357f"
    sha256 cellar: :any_skip_relocation, ventura:       "4ff554ec563b70b7d3e50837b6ef36fde6024839638212cf061e5f683a10357f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d74e9b82e68fa4fd6d3b268633a296035cab1ce83932ee7fdd2537d906f58ec"
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
