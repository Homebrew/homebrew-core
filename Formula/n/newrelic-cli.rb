class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.113.2.tar.gz"
  sha256 "67f0ee804d6463eb614e32b9d5f32c41d2a43f8a1251769ed836a0a4f1b96aea"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a2cdf5d383b935c959532d42c31dc9aa4f81f9856b28be14959632488d57987"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d48e5313b84f2ff2870fbf1476f04b6f43309ea0eae80e8d125bb8fbeb78f7fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddeaee6758b55fff0090a48a25fdd5dd29011e26a3ae13bb2f2094e8ccf44033"
    sha256 cellar: :any_skip_relocation, sonoma:        "69466bc1fd87a61b8cecd8f6f6de23ed5c83c3768362a1efb9b6d8db5bae40d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72b816c1c394b8a1ed6cfeddbd0692230f7c49e1657e7b8edcb22f4488224912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d3c3a3ff0630fa3f22c9ed5d2653947f5e3150c964a8f3ead2d62ee4bb07dd9"
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
