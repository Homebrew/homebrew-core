require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://github.com/aws/copilot-cli/wiki"
  url "https://github.com/aws/copilot-cli.git",
    :tag      => "v0.2.0",
    :revision => "5f61174c563b5f32496544fd234fa3b9efb0bdf4"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ada765170ddf2abfc15ff0751afe0174fb2940924fbb9a374dc6534a10b563c" => :catalina
    sha256 "2bc7b730751a57919e03013c1d8420c86475032db8f416fc98cc70a1155852cc" => :mojave
    sha256 "0767b2ac910c5fc7a1169111f6c1d7437e621d11cfc3e63ee441a88b013cce90" => :high_sierra
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
    assert_match "you might need to run aws configure first: load ini file",
      shell_output("#{bin}/copilot init 2>&1", 1)

    assert_match "list environments for application : MissingRegion: could not find region",
      shell_output("#{bin}/copilot pipeline init 2>&1", 1)
  end
end
