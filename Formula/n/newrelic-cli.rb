class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.104.5.tar.gz"
  sha256 "0e864d21861d4a148d16beee78fadb4396afd3eb5eb95b3920d057ca74b4a480"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eeed73cc595bc540e16ad033deeeb96cb7f27ca9f7cf97423f0c448acb5f1824"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f325d553faf70b028c16e6ea811104e0c95ff856bbee6b27f50dc21f7af23d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb55819f0e55afe6d19582dd79076cac3e507bceec94050671df4951f65ff926"
    sha256 cellar: :any_skip_relocation, sonoma:        "be52004c7f84b4af6c74290066d8b8a19ad27c48776084b148b2384ee28f1556"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b6565239a59bb3d6704e85bf311afe915df04daa8c0b1d8ff79696abd6e00e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99bc02c2aa2e98a6d2d2703b522a90178a78e9b700d45fd3f1fb995442310d88"
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
