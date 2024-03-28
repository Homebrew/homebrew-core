class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.80.1.tar.gz"
  sha256 "da81349c0c4b00ed0fa473bcd588f6d3d5e3d8dac1c6d0c75d65c55d448e8f90"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "697ca5da909d903c9a103c8496c77bc6661611bd4526167337541a1c614bb462"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "705e2fdde556640ea78721371fa3733cd0dcfbeb81142cc5f3d1d90a12417a12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77ca0bb4c2da4f487cff163d7ac022ddfc5c061f1525382dd45798f941956633"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd68563857de2c3d7a1d94aa0eee9b3a68f6c00c3c8206e74d5df6602c74d33a"
    sha256 cellar: :any_skip_relocation, ventura:        "c7357e7b648f1af1c50ae5ab3bdd8a480e37cd1f4c929c806680c187f36f01dd"
    sha256 cellar: :any_skip_relocation, monterey:       "6ca5105d197cb2507e3c74f01843e7d6795dcdc4a5bcbda84ad769d33ac94f57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f754fa656126433af8ab2a501d89c0120d299ee50acf4452aa08f36c310ff56d"
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
