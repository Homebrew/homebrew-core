class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.111.5.tar.gz"
  sha256 "c6271d1c91bb424602bcc46ebbec078ff61fd5e7b3a35670fb541e62871b46bf"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07f390081dabcceafaa7635882e223db72202d4e0c97065dcbabbb05ee4277d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dba30f6ed3edd2aff4074963b2f36d4be734241731f04cfb46365dcd6b2fa81e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a28fca74b996c665598385435f2621fb4c05e62a43e2788aba57ff835e43b42"
    sha256 cellar: :any_skip_relocation, sonoma:        "80459b117f2e3bd038ac262fd742a08853d09b5b7e2706fcce27b5038e64b5e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd3b4a07658486b73656376df26511658d46dcc6f092041b964c9670a01871a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c129b37c585260f4fe3f2c7c2727478e8aeec8986480bbb55d07522c8c8e6554"
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
