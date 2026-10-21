class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.115.2.tar.gz"
  sha256 "3dd77b9339322b9e256205909cf95c7074b4fc58c142e8ebfbebc80739463395"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2c56c74d91a100ba90aa44c29b4383a3fc6b49a9d131ed94f59ec499b359177d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c8c1a0e06c173fd8bb021dac3721ce9e900c45ba9dff3e312a4d68763fec7df3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bb1bcb60f5310f1b8440c9ab5b7be36d3440eb10026cadae09d88fd0bc584186"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0f0449a934d4afca313b69e9ef9f5a8909d32d0689056d595f7f8d388ddf2970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "beb00bcf35ddf0aac016b721794e48c9e3c74a2b3ae9e5a96154b9642137aaa5"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
