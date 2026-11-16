class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.116.2.tar.gz"
  sha256 "a971b81b939a0f69cdecc3713263078c5aecefe79c1fc0246fe9ee2e65b69269"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "72ab2f2c166822bcd812603adbbc16ea4d69ca6aeab84d81feedc593eaae6f91"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fa55e6a718f96d92b2cfe35a0fb7985962ecfb9be7c414d36af1cb701af452c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "95ca54374c7c60454e666af96e0122b78d5e6bef924b8382d50a3a6298344e50"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f572c1f1735d14c444dfcf8c69e744c61608ff406d38ce3456e78dc34583c673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b11490be2db654e8d70715bfaff0b5ad554561a57dee55f724ad295684ec1d09"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
