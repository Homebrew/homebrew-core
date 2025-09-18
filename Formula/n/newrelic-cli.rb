class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.104.3.tar.gz"
  sha256 "4f12f8a9c4ba055d2b9eb2583fa6b3b68c4f467ae34eee41a6b6d7da068768d1"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f90e5840f7b399b04a8d04f9cd40c24c98f5f16fae0c73fa7b0c6578ca2c92e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e3c42381def31c6c0bc14382cf223ebe560166d1d868549f0ed492f29783344"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c016e435725b50f08bcfc1fe6dab7a3d4f6235a79f682aa1e3354ea6ce19541b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8798dfbf2a5e38e409d917c6bae29527b98456693b3966e7a83a055321f9b4cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df42bddefb5568249cce122128a5618440a9bb59fee94653e58c92d2a4f40bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "342be8c54f6d1660b0f7e721387bb25a4fcfdba081e3c320e9bfb2344ab54284"
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
