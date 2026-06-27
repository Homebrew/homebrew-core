class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.90.0.tar.gz"
  sha256 "e35978e4d05151de03f762758bd06ea7e568247200ae93c9aaf919b302d604ce"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89eb3c519784321eb7ebd1de5e413a80f21e435dbaea9e10e786255c8be47f01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89eb3c519784321eb7ebd1de5e413a80f21e435dbaea9e10e786255c8be47f01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89eb3c519784321eb7ebd1de5e413a80f21e435dbaea9e10e786255c8be47f01"
    sha256 cellar: :any_skip_relocation, sonoma:        "26963e4abd1b09146822ba8d08de23f10fff9239bec46eadf6b927c2253452b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "887349aad1eb6095ed1d24b1c22090540b8aad4214d0e83c1fc28c621985f0a7"
    sha256 cellar: :any,                 x86_64_linux:  "b0b16063bacfedcc52784f64710c03f997078403055e8f38b5913d22ec33b0e0"
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
