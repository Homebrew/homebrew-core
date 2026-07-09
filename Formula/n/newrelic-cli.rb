class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.112.17.tar.gz"
  sha256 "804f37ac18b9b0b98970054a21ded9b07edcf740daac8edb2d29005f8e05bc77"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59bb6e5d82f11dd630228b73349ebef74b755b9b7263a29e10f19d7d8f3f764a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "306172f116a0ffdc81e947a50fcc95b6054dc8850e9a85f6ec93766275431493"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2bf8c0c709994bf61db5fb68c2f642dc94c564d81adb2b62e19161f91a25edd"
    sha256 cellar: :any_skip_relocation, sonoma:        "82a54cc9296f33ff6f90bf8baac57952cb912ced1c282ae68c8291805a3364c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "420c6ee036fb7991ffc2405859b2117e930bef63c339478ef8b02a3bad0a5335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd9747bbd5324f03c53b50f39f178a1fb63102889af54a026feacfd95afa5108"
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
