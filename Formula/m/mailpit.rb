class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.31.6.tar.gz"
  sha256 "85889973cedc04644e71cabdcdaf5d77cf428c785928936cc5ab554c0d6f0a66"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6f0866143d280d552f6b43d11740d0e8c564b3460e395fb77caf2f38d3f06d16"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eb3388012d853832da61d8a7095ab5f9b215f462b0a03b3064f455286617e064"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6cb5ca6abd8f9b10405128412f90697476ddd4ea85e8ef055ee7c894afaeaa02"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3c6f36e5c281e0e6718f398629c0cca1bdbfd1c710fc501280f465cfed3d40ea"
    sha256 cellar: :any,                 x86_64_linux:      "2ee77da1a0ec2caad4f7306f79ceff9b8b792a2a8b0d660647dc2167d5dfc36b"
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
