require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://github.com/aws/copilot-cli/wiki"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.1.0",
      revision: "79c165450bb68856f565fd874e21e191e9a873b6"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "00d35d5ada87fda4b7c2cdef4da58e9a026e1a3e942dc30b575cbd8d3a8260e6" => :big_sur
    sha256 "482aa57df717ff9fbbbdea49c8ddb507f7d507121a0cdfa3a7a97d6c63957ee7" => :arm64_big_sur
    sha256 "fc8ad0a5cbb32d5c68fa2e2e20e0fd57aa7d93b0a866329e36b7887947d845aa" => :catalina
    sha256 "c90fa63256de5549f88b3f0fe88b3c3def47866bf5999a71b0fc5e9f7eeee690" => :mojave
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    Language::Node.setup_npm_environment

    system "make", "tools"
    system "make", "package-custom-resources"
    system "make", "build"

    bin.install "bin/local/copilot"

    output = Utils.safe_popen_read({ "SHELL" => "bash" }, "#{bin}/copilot", "completion", "bash")
    (bash_completion/"copilot").write output

    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, "#{bin}/copilot", "completion", "zsh")
    (zsh_completion/"_copilot").write output
  end

  test do
    assert_match "Welcome to the Copilot CLI! We're going to walk you through some questions",
      shell_output("#{bin}/copilot init 2>&1", 1)

    assert_match "could not find an application attached to this workspace, please run `app init` first",
      shell_output("#{bin}/copilot pipeline init 2>&1", 1)
  end
end
