class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.8.7.tar.gz"
  sha256 "3a704c5aa1a0b573c28f5ccb845f8640d284a0016118d3e6f368c2c4bcbf3dee"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6327a37bf6d0da358d45dd256ec79aa55b3495388cdf10d784fd672bcf1b0e36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6327a37bf6d0da358d45dd256ec79aa55b3495388cdf10d784fd672bcf1b0e36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6327a37bf6d0da358d45dd256ec79aa55b3495388cdf10d784fd672bcf1b0e36"
    sha256 cellar: :any_skip_relocation, sonoma:        "7af6b5bf94b7bb17054da18867e17b787f431e3dba5d1097339949cf62cf105f"
    sha256 cellar: :any_skip_relocation, ventura:       "7af6b5bf94b7bb17054da18867e17b787f431e3dba5d1097339949cf62cf105f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "544b010ebc8ee5211bc895ca72bc096ebc2e4bad90ab0ae50e1456b1f28b0b77"
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
