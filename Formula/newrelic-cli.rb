class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.57.2.tar.gz"
  sha256 "14feeeafa34f6cc95d5b1218984b7a655224d8d0d7387b62be3e7e931bac7168"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24449da063cdf1288c41989dbc745800f7eb3a5c0d980747bd1068067442f6fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0204bb9adcea0f05cb274d9e23779f0cd204c7b83f0768ac70cecb425e5e3198"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d74d38c6397d14989e3fa4895744a96cb3b637debe6a81f42e879dd7d60c3e0b"
    sha256 cellar: :any_skip_relocation, monterey:       "c5c3145ad5184d748ce0cc2570a4a02c6854b516cfe429759dd40eceb5559676"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ac8425ba4ba0f3bda7d8f9eeb198205c4223c94839ae4ae854e123eeaeef4ee"
    sha256 cellar: :any_skip_relocation, catalina:       "e7bd91d2bc03c9a618e3458b01ccda1c36ef470ff20f9b86de1b93eb0c2374b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50220f293dc27fa0b119391391c2cee7abec68fc1137eae36d027a6d4872ff12"
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
