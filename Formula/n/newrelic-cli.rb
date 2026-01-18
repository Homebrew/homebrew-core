class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.13.tar.gz"
  sha256 "79421a0a9629167556a0e28c332ff54f11a7fc54849f859b3dc0cc3f08d99459"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "584a3cb3202ce6d5f49fbf484da230b6ab19f7d57c46a13502fcea9cf0a47ebd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "601d7dc6dbe3691d5d4464276512cf2d36e9f1815a07fc67be94c59af980e88a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "608d1f916ae667f346264eed4ab8f9fd0355d851555d2181698689c24724e0de"
    sha256 cellar: :any_skip_relocation, sonoma:        "666a0a711363bf75417ec8d7b04eb4ad4464e275c1accdf6721e6f71e678d01e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8547c39cc867b8a78cbdeb89542056ed3572c38d6da9be9036e6b6fc4a18f9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdc479c5675584d74f5887b1e07178e7b97143141c8a166d997a2a2993f7f984"
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
