class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.30.5.tar.gz"
  sha256 "0a115f7b378f73cf6bc1af14f5c4afd4510eda31aac531f15a4fec26d11a6bb9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12ff45c27648a4dc8c190dece561af9b0ed9709f04558a53529689cfd0ffd8cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb6e6d31c49e5ecad6b49fbeabfb58d77a7746c222ef8e7e28cb2150a2605296"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3eaa183eed454413349f27b7707b72e522174df03afe7d27c460e5891b893cfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "25436f0f48fa378e6a08971de81bbe75b975267c00bfe386435e70afc7dc546d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d95ad6e03b4a8b1e9d662fdfe3a64cfefe52c8378dcba2724d5177ba167602f8"
    sha256 cellar: :any,                 x86_64_linux:  "00abe7b885c5787f368fcaa159e0efaeaa1656597782a938ff4cbe3f0dc4ac93"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=v#{version}"
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
    (testpath/"test_email.txt").write "wrong format message"

    output = shell_output("#{bin}/mailpit sendmail < #{testpath}/test_email.txt 2>&1", 11)
    assert_match "error parsing message body: malformed header line", output

    assert_match "mailpit v#{version}", shell_output("#{bin}/mailpit version")
  end
end
