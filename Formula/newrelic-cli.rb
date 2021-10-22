class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.36.23.tar.gz"
  sha256 "096405e37399f144e637c54fc2f4ad1cb4b07d5b71e2e021709f539625062bb9"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b3cce8d353b538c7e9f1cbb7a653d492cbd864d8a59a1821e4294bd2092d3fd5"
    sha256 cellar: :any_skip_relocation, big_sur:       "c5fc69fd158b6594fc0e449fa0f889e12b2ce36bf75af4bcb561d4205c102878"
    sha256 cellar: :any_skip_relocation, catalina:      "c85a172e6f41ebe772f8e91b3db624e5ad214eb23b93d465b3bedfaf73209242"
    sha256 cellar: :any_skip_relocation, mojave:        "637295b07261fcdd1536d60fb8120536c0294eef7068004150a51f3d6100024d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cf8bc51557334ffc12521c08fe3ddb86c246d9e0e51ab5ee4e0ff3f812dc70b"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    if OS.mac?
      bin.install "bin/darwin/newrelic"
    else
      bin.install "bin/linux/newrelic"
    end

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
