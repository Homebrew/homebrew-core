class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.64.2.tar.gz"
  sha256 "5c07744aa4843ba98091a5d018a1ed3c167803882e9f2c9273fa118c7d95ecdd"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07c22ec89eee7d327100f56dc9f9776bd2ab41003a2ca48334b823a0121b3e36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e7a935b4d4ebd0f7189aff4d2b4a3806834c1408e7252118722cea867cd33ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eee9b88e4f47ded39f570150e8472fa57880054321ccd2bc52f16bca3ff6052a"
    sha256 cellar: :any_skip_relocation, ventura:        "66f3583c5c3f11f947b8c8a174d2764b4a818ab541949904f308f6c3d7336936"
    sha256 cellar: :any_skip_relocation, monterey:       "0db6abace54ee8536c281c32f2d97a5a5b0dbafe1aa7fe023f8b1d7135a8b78d"
    sha256 cellar: :any_skip_relocation, big_sur:        "97c5c1f75f40973d99a14fc48b2f77db106b2deb9738b70766389f83aa9c0b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4aa1f678db8258109e1497a5ac3246c1d78e3b72daa08538b22ec5c725fade9d"
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
