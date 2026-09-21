class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://developer.amazon.com/en-US/docs/alexa/smapi/ask-cli-intro.html"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.30.7.tgz"
  sha256 "437b55f774064e053b0185956afc69ecb38a8b53c996a6e1e49960918b54f909"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ab899bbb64905b1630d5542bc9e8dbf7d1c8fbb9191b2982c22aae447520327c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ab899bbb64905b1630d5542bc9e8dbf7d1c8fbb9191b2982c22aae447520327c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ab899bbb64905b1630d5542bc9e8dbf7d1c8fbb9191b2982c22aae447520327c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "276f13320ff6fa486d1ae63083e75c5e92ef62113ef8bb7421e7984d8a4b3239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "276f13320ff6fa486d1ae63083e75c5e92ef62113ef8bb7421e7984d8a4b3239"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.write_exec_script libexec/"bin/ask"

    node_modules = libexec/"lib/node_modules/ask-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match "File #{testpath}/.ask/cli_config not exists.", output
  end
end
