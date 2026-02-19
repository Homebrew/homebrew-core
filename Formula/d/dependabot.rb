class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.82.0.tar.gz"
  sha256 "78724bf99e251ed80ae527304a2ee697e9b2116d67ba7538a41d6bf7b23cee7a"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72247ff631898021581a17162931b2db1ee1bb6d701f4bfe49a465b9a3b1ac4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72247ff631898021581a17162931b2db1ee1bb6d701f4bfe49a465b9a3b1ac4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72247ff631898021581a17162931b2db1ee1bb6d701f4bfe49a465b9a3b1ac4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fda03914e6838f0f13cd4e221440585c9dc5a8f052478a4ef1e7edf1dd46309"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d02a3e3906e117029b7796404b1380786ecedc1400c06554be21f5dec5a1872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a597f7bc53aea52242c0b6543658d904e3077e4d3e23cf59d996375c22421e2"
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
