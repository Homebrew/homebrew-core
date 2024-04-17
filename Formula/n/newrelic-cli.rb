class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.82.1.tar.gz"
  sha256 "95d9f717c805bd689e7edb37596b536035d4ed8c79be490bf49d24b932d7b162"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94f173207daa5e1da01d980179f8c192ea6fcafe0961fdbff2f52f5f3acb5486"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbdb0c14fd6282fb81327aae651ca1a7fadb52037ebeb25ed2d7f83af657534f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b59255560ea84bef2a37112e2c0e60e0533fb8c50eed1539b81ef4f9560f13a"
    sha256 cellar: :any_skip_relocation, sonoma:         "71146f4d4252c74603ebad93530689125e1c361673f59b358802d08cd01eb8ac"
    sha256 cellar: :any_skip_relocation, ventura:        "e3a49f1b3480125e220e6e1e60c1a308637f8d4af8b96ab3fe09f22893fa4efb"
    sha256 cellar: :any_skip_relocation, monterey:       "1f4dbdb5b712060e8c8227d43d2e8b35ac7972fe713294981461cbd7a6751a73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "690ff20731db4a9005d9406a9f87c579d52309d85d20f402507471c246151754"
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
