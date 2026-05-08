class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.112.3.tar.gz"
  sha256 "0d1244e1d09ac0f6e42bf06768e3357070b9e0d9d7363f4105cb221152598864"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b076e4327e6d4afc08677d0caa62a41021298639e817475bc74f488c026fa97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac7ad91aaac350ba03611a6253ce0fc20d8505eaa76c6304345ae4bfe95175a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d17898b2493f15f82a81768de0524aad1ed6eb51633210b44b9698577026b255"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6994f76c34d3b387097335de80ff24c102376002e6371ae52472c897d871b03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c335ab60e3ed5ad57f8b744bcab3b459fb812ef4b955210ccc19e6c7d7dbc70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e759726d9e61d42de23b9092adbb8a7e641dcad946493ed3e8c4fc70d5023b83"
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
