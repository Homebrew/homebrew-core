class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.11.1.tar.gz"
  sha256 "06a2d6a15e7fb77223e711af69bbca825d9d6cd267a4c207d65f3b06380d34e8"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "65cea2df5a1aaf9b4a663aa74d72fb33a1bd6ae8495a92a6eaec544e3930e7cb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "65cea2df5a1aaf9b4a663aa74d72fb33a1bd6ae8495a92a6eaec544e3930e7cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "65cea2df5a1aaf9b4a663aa74d72fb33a1bd6ae8495a92a6eaec544e3930e7cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7947502cc08918db66199a72000b610800ed1116977dd8d0ee042dde215d911a"
    sha256 cellar: :any,                 x86_64_linux:      "dd59067548ab332d3709ff0b2e8e1df1e190d559d582fb580d588d05494bcc42"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"bosh-cli", shell_parameter_format: :cobra)
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end
