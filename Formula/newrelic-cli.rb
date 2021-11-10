class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.37.6.tar.gz"
  sha256 "03bcf5b9ad28ebcf823fbb2295c1c83c00205a61781b21d96544bc8bddf1871e"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f7fe4d11155cab6a22feda48827a05bb6cc5cbc3797005f01e54f9b764cb9bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7308f9e738e8db164d927ae3705a096e13eda6ba3c6de1c635e372c79d5da75c"
    sha256 cellar: :any_skip_relocation, monterey:       "cb97963d2c0e927ddc6704463b11b3a72dd81d90528f1c764ea3a72e9ca5bcd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "087209e5eeaab33902fc4475fd9ddfb463e51a13a83bfe13682d603a258baef2"
    sha256 cellar: :any_skip_relocation, catalina:       "fd3ff064b8cdd2e5c8fe5d34235557a127be330d046d9fe381c9a1fa04a780bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6be06bdf2234b85975eda60116e25b847aa86c77e81788fdf6d54e98556a9d03"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
