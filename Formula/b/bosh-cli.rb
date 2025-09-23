class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.9.11.tar.gz"
  sha256 "29152576ff3d20629f88317849c4fb5c0c0e43e00ecbd9f4490a2278394653eb"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25b938dc596190a50e3bf41aaffc8a4fdb9c8f15f8e6be07f74d577c9c685181"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25b938dc596190a50e3bf41aaffc8a4fdb9c8f15f8e6be07f74d577c9c685181"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25b938dc596190a50e3bf41aaffc8a4fdb9c8f15f8e6be07f74d577c9c685181"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25b938dc596190a50e3bf41aaffc8a4fdb9c8f15f8e6be07f74d577c9c685181"
    sha256 cellar: :any_skip_relocation, sonoma:        "4794a8a600aa029b080a47f2ed2ef89ce342ef886ba8038d99e9a23fa10c9934"
    sha256 cellar: :any_skip_relocation, ventura:       "4794a8a600aa029b080a47f2ed2ef89ce342ef886ba8038d99e9a23fa10c9934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "265e39dc328d68f6bb1a1f3d03ae6679062597a655f051ba15c159b6bb9afe0c"
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
