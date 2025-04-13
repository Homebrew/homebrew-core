class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.9.4.tar.gz"
  sha256 "5d8d449e57aff589e3386ae2ce9e640b357425cba9214a549b9bc428b2d32194"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a89441d044d5831123cd96a7f04204bed2f5f4b021f20ff7b6577007291031c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a89441d044d5831123cd96a7f04204bed2f5f4b021f20ff7b6577007291031c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a89441d044d5831123cd96a7f04204bed2f5f4b021f20ff7b6577007291031c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d567faa911e5b72767ecbbb7f12c1a57c3ae7b0e57cd9b39fc2b86b1093efd4c"
    sha256 cellar: :any_skip_relocation, ventura:       "d567faa911e5b72767ecbbb7f12c1a57c3ae7b0e57cd9b39fc2b86b1093efd4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "544041ba84faa4386e79cd82e8ae3f8f55dd96f2995426214c094c9a755c586d"
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
