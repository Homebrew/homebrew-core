class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.74.0.tar.gz"
  sha256 "eed228654cd04682f5c95e6d5f488df84d38b52a0aad501c79f2b980daa89ee8"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d4c2cda7f9c4f41f8febdd0a1fd269a13f66994232cf2f0fcc7ca699e71105b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d4c2cda7f9c4f41f8febdd0a1fd269a13f66994232cf2f0fcc7ca699e71105b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d4c2cda7f9c4f41f8febdd0a1fd269a13f66994232cf2f0fcc7ca699e71105b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d587d2eb0ff30668181cd391055f26590554da5ffb86cf87bcb9049fdcd7b5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a08feae627405c4117c267fcf5b8ac4ca30fb05c3150456a8d2f946eb052082"
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
