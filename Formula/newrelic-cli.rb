class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.59.1.tar.gz"
  sha256 "9f7e2c9a788b2945e05d6c7bd7cfd966f02ae9dee3f7357766412a33307a583d"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7029b964c0313bb15ccf34489c5d273e4c47a8653ae4d790fbfe2da6ee4b925"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc20fa5b3a2da4b194652bb0368a1101d5e3ed4ac52d0f6d0e7b41f01d26d6d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d31108967da503b06eb2b0dcc0f4262b56bcd209136d7ddcb098b304f1465e46"
    sha256 cellar: :any_skip_relocation, monterey:       "afa95a253f1ea50122067dc9ac754b1568079dfd05e81a8c57e2c834c632b9c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7d0769337a23e59293f656080253b85da3293aa0871a3580c23939e69932035"
    sha256 cellar: :any_skip_relocation, catalina:       "c22e141f3d3286b4cc3cb368ce3b02f4756a304ed5d3fd40272ba5caf354da37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "127ca5e2dd398a6f9879f62295833414032c8790adc97ee4f216cd31c5fdbb46"
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
