class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v7.1.2.tar.gz"
  sha256 "f3f768f0986aa1d81c7389ccca80fe9ed7144e42baaddb1c5e265156459939bc"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ecbe95f10c935af954d42576d74f8374bf83fa8800c4dce24799aec2c3e8d2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75e1660d55c436f19ae72a825bed04527d05b7c7b5433d035bd6e41fdf050f09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "961d2292185e94470810449934001e584971db843c1c6c0c1d83e2dbcf5629f7"
    sha256 cellar: :any_skip_relocation, ventura:        "4a3a5a5c055c762c48f98d73542ddc6ef0b9ec09b19cb9a150704228d65b19f7"
    sha256 cellar: :any_skip_relocation, monterey:       "e4c3e37dbe4d2f70ebde339611f1938ceb460b6bed0bd707c72b1220858013dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3c3533eeec5aefe7e8a585a5f09297df905de2608bbdb0357f92e2255ed8b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea3fe2eec2dea6993038d9fa23e169199a15dd85c757f0f8024878d69caaabbc"
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
