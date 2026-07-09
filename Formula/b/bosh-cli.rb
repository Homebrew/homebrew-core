class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.10.6.tar.gz"
  sha256 "1a168942adc079acea79c96f25438243d62267f18ea86cb4cfa03083bf7ae140"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35f21f0b6d0e54bba31a2eb1ebdb19c0d93def0854bbe03b9a540da46e60dac2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35f21f0b6d0e54bba31a2eb1ebdb19c0d93def0854bbe03b9a540da46e60dac2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35f21f0b6d0e54bba31a2eb1ebdb19c0d93def0854bbe03b9a540da46e60dac2"
    sha256 cellar: :any_skip_relocation, sonoma:        "dddc3507219297f89e79e77ff38285d77c933331897d5dbebbc9efe242a7872a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40744f4dc67097f68f92119a89de465425d65e895fa54bf57d537a6cb4a57b7c"
    sha256 cellar: :any,                 x86_64_linux:  "6bcdcb2d1b413aa9fa70f3fef9e937d00c8ab2d82c0bffcb4674ce964e0c9143"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"bosh-cli", shell_parameter_format: :cobra)
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end
