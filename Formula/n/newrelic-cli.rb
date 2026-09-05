class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.113.10.tar.gz"
  sha256 "0a8ff2a86333f35fd1006aa087437cba1a3d7c4870294048331ad7b83bde5e7d"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72853728fc80dfccf27111dd6e7bb61a55b72d2d1303a99e7fd46918f5d224d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a500def5e806510f25c095d27cc3682839cdb0fc2a832f142a2abd5281a3f72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24601d209807643dc0f4e178a37cf78ed8d3c0668709d6e6038eb8a121c84ccc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d96068c5514f66c977d37ede895fe4e216713974a6aef2aba0ed0839ee2d824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6af35c040858b7b9cf1631f7af7c79647a998cfce3e054ab5bf132fe7d403d3"
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
