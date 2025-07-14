class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.99.7.tar.gz"
  sha256 "74b43f2a6310e9d00c81f7a738a7cdc4e22e084a46c7825642b53051571e00e2"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13b9ee8e5a6acac6ec5a5d47f6bec27f3ed4b686d74f312ffd6a4e6b62b1ab42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc61d504b79940a48bd59d4c56ce0120be2ed67117e14134888a3e481db6beec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c28bf35ba698b1ac5c78c7b329378544e262521c1898b5fd1e76d47d51d1e38a"
    sha256 cellar: :any_skip_relocation, sonoma:        "94bc6576471cf15914b7e7016fe50e1f28cacd17e7e2ff07e7da61068fc7e313"
    sha256 cellar: :any_skip_relocation, ventura:       "4a05a051eeae439afede5cb9a9d3673453531bcc1081193f8a50dc7b4fb7363c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b25d13adb4049426cee1634116b333e22f2a8f2ad08b0ac3569620c22fae6ea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1731fbbf65487b18c41f6c0aef08342bc54d6d8f1d5ad4dd00b7f81845face8"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
