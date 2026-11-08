class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "db2b71b4b1a535e379c62db72f1bc302346fde2dfecbf90ed0780ea2de1b8798"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5021e8018c9d0cac9e86cab6a3d733f5b96230085c8f93002700752eed442803"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e6fe77071d6f105bb4f59a2e21b067a162efed1a3e53104d97faadea3143008a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "844449664896a77688c3a0baf165b52d380ab92dff8804a4bfd07a5a2e758c30"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "52f7a14eec00633db7a88999183c25fd907754b9450cf69ae8449702c9ae42c4"
    sha256 cellar: :any,                 x86_64_linux:      "63ddb1c8b844eae109a76c835583dd08008cd1be406f40f4faf83d7359ce6597"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  # `mailpit version` in the `test do` block checks GitHub for updates
  allow_network_access! :test

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

    assert_match "mailpit v#{version}", shell_output("#{bin}/mailpit version")
  end
end
