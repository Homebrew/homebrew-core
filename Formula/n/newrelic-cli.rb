class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.97.5.tar.gz"
  sha256 "2fbf3d8832c0816587b24b22688e9e20962e3f73fc4c476d2081cff24d2a6e94"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "378e18399639f9af68cdd73b94a00274f87f3fd5552fd1b5341aaaa3ccfc225b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75bb41580ec3329476f765393bfea23cdc0fb7977f35931e4f098cd63b01fdfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8100284401749973b05dcf26f9fb90e6a6669e4d949c316a807d6fd53ac94151"
    sha256 cellar: :any_skip_relocation, sonoma:        "5edf589f7e7f23ab8a7298dcd875bf20cb3a4f6bb1034e37b5ce20bebfcef4b3"
    sha256 cellar: :any_skip_relocation, ventura:       "9bdfabd20159c2bd98c4b54bd571aef08bb78a8b6d9440ed8aaddf67896e8d51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91fcade859ee5eebf136db4e846a48f4e4adf28bebe7391b21372ccace86de75"
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
