class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.56.0.tar.gz"
  sha256 "07e12f9ad29eff7145ef8a074137ce8bfb8eedb7a7fdeaed92542b5adf341f25"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a93d8de16c0abd24613144f0314805bf214f0152286fedcc9b7d9006d63720a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed2b515ef878328fdf70bcbbda3c583e5360641ff47468a7b84ca02a194e69b9"
    sha256 cellar: :any_skip_relocation, monterey:       "46877a3e848eb42f2792f83359020e9f17c4b6a2a45ab4438b4ccdbc0ae82b8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4bb8dad02aed4593dc335c0924de8145581a687f3cc95b0a8456124641470ab"
    sha256 cellar: :any_skip_relocation, catalina:       "253d86ab13a5caf86cbedd468772e7c7bcf744248d3071408360968f30ec8f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "283ed63d94c2ec18894299e599cecc514146e8fcbfb743d57a4e8ba2c9a39318"
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
