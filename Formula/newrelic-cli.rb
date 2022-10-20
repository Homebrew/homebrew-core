class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.55.7.tar.gz"
  sha256 "122f902bd458cc6bfeccfde1193582138f8335b2ac9b6b1a97347b859a4c17d7"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e90dc5c5e1f1ed35ff0616e79e6c016f16b7d16235bd37398bc197a0c130531"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94852a5510cf8805f7d8c45180b465104068d3f00a74ca37f39076c28c98f883"
    sha256 cellar: :any_skip_relocation, monterey:       "fefcf79e5083d7c956950ef3228d293914e13290e36232e948cafdeb5410ce60"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff83a13b4a0c5261d5b83eb5410a05c9853dc6453cd221279ea1dfc5d7d40c7d"
    sha256 cellar: :any_skip_relocation, catalina:       "93d5c43decf4c5d48719a5c7ac5ce673f9c3fa9b861fbf8de1e7a6a8e390d83b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c69e88f9353c695927d9288269c14d38db72900c6e7224433c06866b604e522"
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
