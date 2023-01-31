class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.62.2.tar.gz"
  sha256 "293b62d10eea23e0bdca66e2c75fd3e82dbb3b01b4ad75c65c0c15e3115ef074"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7e170bb5616d18926adc87ff3beaaeb842e0e5ac8f4542c05c6cc210bd75a83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1147e7164ddb15b1066c110dfafee2a866e5fdeab4e25e2caa2b058e5923443e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b16247e537a8c97caf557294da6a9360ba424941444ac100321ae27970937505"
    sha256 cellar: :any_skip_relocation, ventura:        "188f247924011889b98715070da74b449db926533776be826b3c922e67737ef0"
    sha256 cellar: :any_skip_relocation, monterey:       "9fa578177cbcbc0cb566e7141b638460d2a5d80e44045ac07a18f38b5186f288"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee20bad4d116b60b7cb547dc3ee0d375366fc72a1cbeb5042d83a21065238455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31f5da8fe6e31271b008f1546998893100b776283cfb50f70929de9d492dd9aa"
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
