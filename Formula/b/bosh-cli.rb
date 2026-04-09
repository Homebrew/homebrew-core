class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.10.2.tar.gz"
  sha256 "68719590e33154a44067df21b5be8a137049a76c703cb00cf0671732f01eeeb9"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9503d7b70f2a9a7ed8d3a3fb954ed989d7cd97a0a18bf5985ed841efa8febdad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9503d7b70f2a9a7ed8d3a3fb954ed989d7cd97a0a18bf5985ed841efa8febdad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9503d7b70f2a9a7ed8d3a3fb954ed989d7cd97a0a18bf5985ed841efa8febdad"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab640d86ff364fd39101fa6000c18f7b504d67ee0bb3d3e9d89e454f6be5c534"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee400a9d8ad69254d7cfc1975b479e615cee0270ce6a8d7629ad4f3aa62fa892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05bf669e107f8154590c50c90d5b795fd458ebf5d2476bdee0a1a39c1b115ab4"
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
