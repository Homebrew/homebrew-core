class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.96.1.tar.gz"
  sha256 "3db067222821ed88f88d56f7c904e8cfd4c6c93fdfe15b567bb2ee83201e8d2b"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "155066ede4f8912e45fae6f76e83d752863784e4c92899c2767b33b438859b57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da63b0a9d74432bcde3718e347271a63a97271f4ac90b8564d3913a25dee4382"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58ad7e653b5fdb67ec2c0890e8b623ea044bcdba5ba7523e460af6a0090f9442"
    sha256 cellar: :any_skip_relocation, sonoma:        "92ad8f5b0e54f0d9bd243929588508b7e60a49b4a39251b3d1a576e20d8d1fd2"
    sha256 cellar: :any_skip_relocation, ventura:       "edd6d2dd6480e2139e81576e0b606e737e92120527119c5653aae69b00ed2376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a169173e667887f477f464609bb7b7574881e529d3927658ea7adb067e107b94"
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
