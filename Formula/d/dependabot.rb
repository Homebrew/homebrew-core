class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.92.0.tar.gz"
  sha256 "11a6cbbb69b75428a0abcd85f7e118c87ba18b2d00cc56b3dcf52379e0f54ca3"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "277bcf1556bcb32cd8784d4655bc97de003684fa60e714eeb76802b1649e1a35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "277bcf1556bcb32cd8784d4655bc97de003684fa60e714eeb76802b1649e1a35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "277bcf1556bcb32cd8784d4655bc97de003684fa60e714eeb76802b1649e1a35"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1897ce062452d6ebe4e3ed6686e089f57e01ee0ac180147cb24201dfdf1a1f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de69c6ad8668a1e6c262e6c430ab1e4ad7c3ae0d739a32ee48d8362acd71a5e0"
    sha256 cellar: :any,                 x86_64_linux:  "19d776c916bb5dfdb0f22d246d5a3dc4c2646d90a3404fd16b9236466dafc9b0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=#{version}]
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
