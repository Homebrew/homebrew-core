class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.9.14.tar.gz"
  sha256 "761fc707b625af36f7d95c7624a09478c6e728c29f524cb16f7a1ee435a40142"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "724c8497816e17d1358fc2bc648bd26a5ed803ee406365f495f941017bcf5f1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "724c8497816e17d1358fc2bc648bd26a5ed803ee406365f495f941017bcf5f1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "724c8497816e17d1358fc2bc648bd26a5ed803ee406365f495f941017bcf5f1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb75ed0a7881f17ce0884740fae50858a67c0747c3fc8e8f3da4827bddb520d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21fcfcf737722c0325e835451929f6f2d9b9a0e4efe73b8e80961b13d1eef838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9685be22a022bd76524b780cc5dbe94d3653888e85bcfccb3f1416c6e92e6c72"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end
