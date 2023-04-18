class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.67.1.tar.gz"
  sha256 "3f8ff02409996081d2a2fd3cd1f7e906404559258026cbf0b031198bade490e8"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7742baad2016e9ae6269642e7c9f3bad5b8447dabab2939763456f7579d109ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba640d28e50352a7ee2d7b5027005429c2b26eb08260e0862d390a7742ae0931"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f17b95272f1c9354933bbaab602f1bea2916878e43c4642efad3504b0cc74df8"
    sha256 cellar: :any_skip_relocation, ventura:        "cac1c8bd191c4d2491d46aa4c49232159c4cfa63536c9f7ddfea5a5e3c5a0df5"
    sha256 cellar: :any_skip_relocation, monterey:       "9d235c910f23940b4c3318ee9ca277987fd4174b8003a5e6c99460467ed5dd38"
    sha256 cellar: :any_skip_relocation, big_sur:        "b60b622d5446aa08efa8c2e1be0a775856ae0430e4b151cf35a7cfc9d297f914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af89e3e249c28471c27c26d7c1716f5a2d31ef167fb768ade88ddc1c8a379989"
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
