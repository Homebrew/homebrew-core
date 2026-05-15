class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.112.6.tar.gz"
  sha256 "19b6570433e025f0b4660822258f6ddaeb09402db38b0da8403665872621b21b"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fce5c3c5a99c678f7d957226456b46fddda91fe1e951aba7cc1d3a4572c04930"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc2fb7166882a6e06ac71706783fe2c4f622c7cca1521f5a733cf24a9e09e0c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8fae182b1caeb465b0aaa11e6120140d2a6ccb23b010ea4a8925946b23d424e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c51148c9bb762f1f2ad3506441776d50536ca57985d43d3d322d263a869c5f0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d2adf861d03a8d53bf6bbbafce386c84fa49cd3a5df454375755be5382c4faf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e79d430c183e692b40d3da25d6c005c965d7425da2320407f67e8c890088e9b"
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
