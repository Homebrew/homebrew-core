class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v6.4.13.tar.gz"
  sha256 "f5c61ab0d863668804e06491ea8c0b6de41d58d30a1b0c63c2e519f5bfaebc9a"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da6ce27b977874bab402fdf99ecc94780c764d0c4b0ff0d2065439bf019d96c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24636af98ae15fd41f715b0057588209eeceb6ed9583c40c1b0031d51255cde9"
    sha256 cellar: :any_skip_relocation, monterey:       "451b75a923a8c7e151da8ea7a1dfcd5dc8b0972f87013c8c3e2035f452fcc079"
    sha256 cellar: :any_skip_relocation, big_sur:        "5420daeb3be449e4ddb4471c8d7595d52c76d17f55ceca850225dc419692a7b3"
    sha256 cellar: :any_skip_relocation, catalina:       "0772247314f71a58dbbee017b662a508c97bcd446c830c0ebc6afaad84a936ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98e00e9330276b040fa3e138503d5ef25cf1874d362973ec5f0bfbd7102b68ea"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_predicate testpath/"jobs/brew-test", :exist?

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end
