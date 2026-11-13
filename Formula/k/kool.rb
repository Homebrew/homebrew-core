class Kool < Formula
  desc "Web apps development with containers made easy"
  homepage "https://kool.dev"
  url "https://github.com/kool-dev/kool/archive/refs/tags/3.9.0.tar.gz"
  sha256 "af98db1eb6b7e90f528ae5802a059c563881de77477909a90f7bf9d2b47e70de"
  license "MIT"
  head "https://github.com/kool-dev/kool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "925e50b91292e72223a83724cc69b3788866f3640bfe662af865a4d26a494612"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "925e50b91292e72223a83724cc69b3788866f3640bfe662af865a4d26a494612"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "925e50b91292e72223a83724cc69b3788866f3640bfe662af865a4d26a494612"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f672ea370c5604e6d3eb2a0398684f8245e2ada3afbb18a33d4cada65edafdd3"
    sha256 cellar: :any,                 x86_64_linux:      "acb89f82659956643662db44d8d25a2dda5090811dcdfa4d406f47076fda869c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X kool-dev/kool/commands.version=#{version}")

    generate_completions_from_executable(bin/"kool", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kool --version")
    assert_match "docker doesn't seem to be installed", shell_output("#{bin}/kool status 2>&1", 1)
  end
end
