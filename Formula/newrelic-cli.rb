class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.61.2.tar.gz"
  sha256 "6d97fb5089993afe829c513ca269c65dcfbeec45e0718e2d2f2af49744569d2c"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3e6fefcffdc131a1acdf3a8ce0ef65b50c0963fc6685cbdad3184b59a46e57f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec84b4ecba5f5e645f842798820015a302a636de9cfcf7bb1bd5ae2186a5bbf0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bacbad8234e9b7726c23e2f3876eaa5bea623aee73bde43ff9d8195e08480cf7"
    sha256 cellar: :any_skip_relocation, ventura:        "dec23256732e75f7fe2055397c184174eae5dfaf209e5e2f6abb88d5878638f0"
    sha256 cellar: :any_skip_relocation, monterey:       "64ed97cb7fcdf0b20d52aae9678de8a3ad6b7a93e5f5817f4403ac0725c445d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c647956f8d5298635e81af7a483f2c4b53bb96db9e0e190a6117a673a98d2f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b854c623263e1526b26fb6281f801bc1364b9fa4e9418056c0a619f0d18e7210"
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
