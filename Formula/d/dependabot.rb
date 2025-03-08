class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.62.0.tar.gz"
  sha256 "c4040db89c030136b6dca361a6ab27676dcfecb492143cc26dee3f7d2af69627"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11b4fa2e40858a007618ca5bcc49a3c931529eb575b03476e8fb52d46b6e4af0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11b4fa2e40858a007618ca5bcc49a3c931529eb575b03476e8fb52d46b6e4af0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11b4fa2e40858a007618ca5bcc49a3c931529eb575b03476e8fb52d46b6e4af0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6de7ce5cb9a4105da4617fc335d2d5754d1bb0518aa4e355e20ca3387bb0b1af"
    sha256 cellar: :any_skip_relocation, ventura:       "6de7ce5cb9a4105da4617fc335d2d5754d1bb0518aa4e355e20ca3387bb0b1af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cd048adcb96bd6552fd0dd984c6429a8d587719e83f57014ad2bbbe42fecb25"
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
