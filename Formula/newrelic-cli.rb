class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.41.13.tar.gz"
  sha256 "83693cf8538c4c6dc4c51bbdf1b7d28c40e3841d2507d6449c4e1680ec81fcc5"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4830ca1fd99505565aaf642ca7f00ebc6b3fa6c240c982d1eb9fb972d1cd9ed3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1571a56d2505ad0af78b7285aa5acbd73ed0ccb1223bb4a84e62f7b5bff43613"
    sha256 cellar: :any_skip_relocation, monterey:       "78e0ce9de0a3b5f17101b33514d214b2d0259bfa45302b009d2c845fe45adc62"
    sha256 cellar: :any_skip_relocation, big_sur:        "b16c32228a5cf2e40897376db95b13e5dc0693ddb06c85c1a3c62c38f480807b"
    sha256 cellar: :any_skip_relocation, catalina:       "6ed8da699a87af25a772b663ced45cda2eac9b46a493de21fc9382385fa78f6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1a0f5d5ee77eb866bf1bc06fffa6509b59afaa399d0fefca2d10e422ef406dc"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "fish")
    (fish_completion/"newrelic.fish").write output
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
