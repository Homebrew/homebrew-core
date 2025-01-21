class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.97.3.tar.gz"
  sha256 "2d52d08444e48091885c45f229ce273c387422ddf980b6b8fd6ddb9d645f15fd"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc8d78c0b514716bd19ffd8eb943298b2f0e4cddd1cf378bfee29b6ac657bee4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c580cea29ed85d0cf2620786e760de77b9f1c441fb24d84cb6177fc463fa32a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b83cd7e2c926b95ab72c8b7ddb52be6f85be66ebee4a8140778a803e7fc0e89"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b4c12cd600ff8f4f40aba7ca257dba60bfc9f241e924a56bcc7dc06a7f76c16"
    sha256 cellar: :any_skip_relocation, ventura:       "cffc0e00cc79ff4c04981532968e15699b7e5fea0b4e59777317dea7e447214e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9940e01a33563001532ce6ffb41fd3c99d67cf467f41eb1336787b28afca45d4"
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
