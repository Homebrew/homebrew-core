class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.98.3.tar.gz"
  sha256 "c7f96f47f7683458ad58b54cfa6b940a0c3b9da03c76fd363f7e1ddb70436b80"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08eb5f9d97e1f44271e94bb0039fa2af6e88a8321d349bf358f1d8f2a7217a2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4a52f696b5a26913d252b16b7a501fe444261f20b6301e66c0e2801094ef6a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98afaae13107ee20f2b0157a78e7b7a8ec6c6fb73100a3706e49e0d25e8732a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6f59de5f961c1dab810193027dc4bc4698d6c2b7943f81fd6377e54092238de"
    sha256 cellar: :any_skip_relocation, ventura:       "86637ee7dfc5fec9763e96f98e698313e07d8aa426f27dea04beb1071c854f9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d11bc167876a3bad23e97223e8b3865501c2ddc493d5fa717f24d0ad6f0c37e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d48758c74c18bef65d11cde859d6df4a752aee0c88172a27cd92c0b8ebc9162a"
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
