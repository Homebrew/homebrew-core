class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.97.12.tar.gz"
  sha256 "5afa6a21a235c12434f5ae13d253886bc235d08eda6c456b6221b1ed101e089f"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d06b88d2e489e6bfa942abe7870d579bbb66c9567be5ddd772249e8ef184e5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e170a15546f82a43c4b173ab5d6a855d59ff3ea35640ee9492f6dabc14fc437"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd381c1835f40f640d57f8b7c50cae1bd868ec7cc9a7301a4d94c1677b9818db"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8b8320b6ddd2ff4b50921ca7cb2b990564adcd95de95b1639ca9f50658fb51e"
    sha256 cellar: :any_skip_relocation, ventura:       "b1bd47adf1259e708679b4a15c07009876c135f7d82fe70c2697f73375f86b6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d842c5e09dbf75410c73146c53c3ed3f62d8e023de1fe3942942572e0ea0a314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43dc8e8e9e820fce1195f82a5f30643783196e31f140c7b01786a621cd2bb4f2"
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
