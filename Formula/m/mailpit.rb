class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.28.2.tar.gz"
  sha256 "c3b74fcd7acbfb93c71e213d3e3c56f6cbd680944fe1a41339e99821c7b94acc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2e9252fa50aeef13c64a10773d8a4db752db228833946adcb942d1d41500525"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a9117211e544275283acb45e8af6b26be949737b03cb3b19866f583d90f5e6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c4fc873b13fdacea4eeb1a4a6e28de8300821039fa308664529b6700e42d526"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c93a7628920f648c6b0c3f6ec3191fd3851c1ca5287c2d9b3151f6ac5a390bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70af9284e221b5ef2278f0e09c4aec1822e17ea005b2d0af1305502f5d8333bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c694cfd1243251bccce6233468fa809b072f882facf2eadfdf540ee3fa8712f"
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
