class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.104.0.tar.gz"
  sha256 "84770dc2b3e84d58e0d28d735220fc78e7ab142f61ff5dc2d0b4eabb981d3e35"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f988e61c44908ffb38dcc77171af6c11132e79bd37bfc521a4fe6adf6eea1142"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67e19cb87f3f8c33b450d54893059f855bad61a49a7b06bc73b3c4e853c3acdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b55b5165224395236013a8e43980f66c553712ce137a466bf03a260e7061dcab"
    sha256 cellar: :any_skip_relocation, sonoma:        "9513a3b1dea7aebd00b7ec6ea3760aa44e207d91a2a92d1eefd68443e82a8ed1"
    sha256 cellar: :any_skip_relocation, ventura:       "ecc7b8b8ef0ff3d535c6ca64ebb660c035b30b550ef346532938a3b124972c11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "511d5945f7a52ea50d8ce2d1857a72535dafd324611253b5b046f372b9d4a12f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4992b3a1fca53664a98239bb2d3ed72eeb8c4860f55819f36ba862300d13a15"
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
