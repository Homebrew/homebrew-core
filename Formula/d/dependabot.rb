class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.62.1.tar.gz"
  sha256 "f985196ea5459e65e8d21fa1ffe85d7c48b1ee61ccdfe1e6667176390c8ea990"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ae8d99321387e298b2ac298dd357442a247f7f49af7d5ff45e17ef060a8c693"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ae8d99321387e298b2ac298dd357442a247f7f49af7d5ff45e17ef060a8c693"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ae8d99321387e298b2ac298dd357442a247f7f49af7d5ff45e17ef060a8c693"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c79afeb5cf540e87a0192df3465d03fef77ba36d33dd4b13e1d0781ede01266"
    sha256 cellar: :any_skip_relocation, ventura:       "7c79afeb5cf540e87a0192df3465d03fef77ba36d33dd4b13e1d0781ede01266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd41da07bd525ce37132d6cfb74594347e8890aea7164f2737bf40dc60fc0286"
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
