class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "db2b71b4b1a535e379c62db72f1bc302346fde2dfecbf90ed0780ea2de1b8798"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8a5e884d5ac9d1851cf30285b80d429cc395e487d075b61d1131bc02ac8c7300"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "627760f99bd8513dae98d1b757b90cf448d2a69d54b6a00a79efd5f4c3e8575b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e4aeccdf2b495dbbb1a15d8a2529f7d16701c3660d3a644dd0ae54c9fae71995"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d4a1edd9dbd3b61b70f20ba3ae2b7ecbef1043cef7d6cb1e7ae507f9cd8c9d39"
    sha256 cellar: :any,                 x86_64_linux:      "46a85635ccb3f011bf29937d9615329ae78fe5782bf298bf5f91f868df96296a"
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
