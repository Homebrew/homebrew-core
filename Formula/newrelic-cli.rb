class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.67.4.tar.gz"
  sha256 "5dba11ed8f7115b6ac0436037743181d56c142c111ce21e2125d6776d935a86a"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0db338c39f1bc20eedf1482a4b9116802588a60358fea72e539503a3300580e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3d5a6e1d3e74fd07a41d25076e25ee757e5cd615d8ec60f84b455b3cd9e47ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1cdfaa98bceccc26db373e5503537067d93a73f77f5ed091917455e2a0e7944"
    sha256 cellar: :any_skip_relocation, ventura:        "abcd844923a3bde70231ef23f594589fcbfa90ac4d63e35e191f190d78bb86d0"
    sha256 cellar: :any_skip_relocation, monterey:       "903af3d6cd6c9fa9ca41faac577d1031bf6bb2c63361b0ccf5909d644410ac8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "42f0fb076aa577cab39d0abed800d9bf0eceab2ce4b29345cc9a85bc2c7513bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa302090b1271c871b588788eba62cd95a327224666cdc4d490b64b1514f5fa9"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
