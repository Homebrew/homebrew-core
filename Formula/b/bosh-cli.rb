class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.11.2.tar.gz"
  sha256 "f2b25045096ee3c58a7c7e691f4123b9fc6d23885cf61024fd8ef930aac20494"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "66dbccfad3b931828649c560671b1ce47de5de1b3f9c88be87f1eaf054d9d5f3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "66dbccfad3b931828649c560671b1ce47de5de1b3f9c88be87f1eaf054d9d5f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "66dbccfad3b931828649c560671b1ce47de5de1b3f9c88be87f1eaf054d9d5f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5974eb193dd7889ac81b794c7ba899d949665b2438d520c4c7d9f1db90850d65"
    sha256 cellar: :any,                 x86_64_linux:      "5f132d5ee83052cb60380c4c9794448f7d6b9eeea530f390ae53cd9a079d44a3"
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
