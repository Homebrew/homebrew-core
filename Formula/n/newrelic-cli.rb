class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.15.tar.gz"
  sha256 "8a07d958600105b89b40a47241b6009182f4609e4c01e3e7079470f33df72f73"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01b0a79d9d976250b89328fb7b7a6601e25cf67462a8a017282fb615d8b40a5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82f0eff6903c499f4451c4277e2488108722430f01880c6b017f5a2efb22ce6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86f19aaa41caa7ac6491b5b5f28e71cd9113070ed2fafd48646a01c32b2091c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "22ec35fa29ef0f48cb2544d1282f0a085d4bc03a1bae4c5b2205f19d6c3248da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a969146e6661b8a17e91102529df93145e5748234869772d441431c79c5caa74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a34b48e5ac3f992a16cf052a707645a3ed822822f215de455ea1a2fa3776c55"
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
