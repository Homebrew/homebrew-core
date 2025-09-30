class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.104.4.tar.gz"
  sha256 "0a3f9b8090da404fc8376a7f46e47ba886ebecbbaada6cb3b156efc5d8b61d88"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b04fbd28395effbb5e44eb6a1844b69d20ac14d394d968f322a7fe38883599e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e751a69ee058414b26cca3373b8489a6301d028d13c13ab675451daeb2b2982f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb49adcde4ac3ea222668c60903f55f80f590daec2b3c243538279df59f77497"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cbfb5f6001244b473566967671f64d58eb5bd16c90f849a445079c218817f21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6bc4d4acd2ae879f9159a1662dbecc172cf89f1a1ca884179a4a0eb590c8a24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "944e4ed640b342efef93cb8b5fbc4e15050bac72e1a59dd5ebfe3a9492b33de6"
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
