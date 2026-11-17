class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "82e31ccc0069685f8794ea0d781cbf147f717633d3bd0f442883ab36ee6308c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "63fa51c460c47e0d57d953318c4d89bb2f58e2367790f2911935cc2b33bd6f53"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7d0bf9105570ef31c3ec4bedd9b16d2450ca151369540fa46c74f10aef1c8e61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f52aef205338d79c555673aee0e7af8ddffe6353a431487005aaa1d5ea1a6ea8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7c2dc3887bc29a2281d1e83e9333fa56445e664221e875bfd939825c5f4c33c1"
    sha256 cellar: :any,                 x86_64_linux:      "8f24cd7186059c7e38e0fc34332a905c9acf5feed12f5ce8825977394e9174db"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
    system "npm", "install", *std_npm_args(prefix: false)
  end

  def install
    system "npm", "--offline", "run", "build"

    ldflags = "-X github.com/axllent/mailpit/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mailpit", shell_parameter_format: :cobra)
  end

  service do
    run opt_bin/"mailpit"
    keep_alive true
    log_path var/"log/mailpit.log"
    error_log_path var/"log/mailpit.log"
  end

  test do
    test_email = "wrong format message"

    output = pipe_output("#{bin}/mailpit sendmail 2>&1", test_email, 11)
    assert_match "error parsing message body: malformed header line", output

    assert_match "mailpit v#{version}", shell_output("#{bin}/mailpit version --no-release-check")
  end
end
