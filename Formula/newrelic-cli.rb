class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.60.2.tar.gz"
  sha256 "dee9702a43e150c2e233f432b97c2a47cc963f083704077503665e7f45f3b491"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b32e012eebe2ee435451fd5bf58530deec036aac1b75b224dcb00df2286f9c02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b11ff5015c92e12d5c8754b6795ce6ae9ca89a5d74cabc87ae84a5f71605bca9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "694e61ed5522d28874ea758a43165b83f138d3ad6a5aafd3411601fd9c615f7f"
    sha256 cellar: :any_skip_relocation, monterey:       "9a36a2b525ab7c1d779111dcec7715ddec60ffd99cba03b5aea596c70ca4f302"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5dcafbeb7317ed6cb4bf7b7d863e599b433b62ec9fa2f1ad3130c6ca54a688b"
    sha256 cellar: :any_skip_relocation, catalina:       "b6601037752e99063284c951c2bf01b7a8345f1b85af5cbf70e5d1871f5f2a70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "079f836ab7e723b5194fa27ea9c558f992551b41f0cd0536194d4e171f0e2aca"
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
