class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.64.3.tar.gz"
  sha256 "7d511f1d8638c70620d990f27ac8005483bf18984c6f2024a1f00e0e926a3b30"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "464bbf8405acd4d93c703166ff4481c77aa14ecf3dc59f2c227ba8447897ce07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de564a82c1645c0363e05e1725df689a6bde9a0a4d2166eecaeb5e5ee049b817"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d767521e86ca36c1f11ac01a85433cc55348cccf0d42c51e4410c6b3cd9efe1a"
    sha256 cellar: :any_skip_relocation, ventura:        "ca47a18e11b81d2e7d5b5225363d0692e54cd530ff95834f6db4358fe1676613"
    sha256 cellar: :any_skip_relocation, monterey:       "823d50e6c3ed5e0ae564d42f219f717fc261de91a46f54ce235605dc1916a94b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3548dcf6e58a14b55d0275da545ef206c8961e51830dff7d3dad6fb4feb27c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2549cf66fb27f5eb60f390a4b2cec37b121a0a40315e47057335b3d0275ee508"
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
