class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.5.5.tar.gz"
  sha256 "79770d8b80e6e99c97b64fa42172f8d6ea868b6e7c106a594cfd062331457564"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b6f7e1c9559bbaa07105b82ab14f303b2cb689f526b4e438e06c844a7af6de5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55a909f2eebce7da76a823ba4e7ee32cf991dd82be0a2972bf41b6fd77886179"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a82c85bcc153814ff32c20776f727203b6342684cbf16030039bfab8df1bbe44"
    sha256 cellar: :any_skip_relocation, sonoma:         "a00559e6915179bfa6d62839834db4b60040d54ee24d139bf7266f28ce806252"
    sha256 cellar: :any_skip_relocation, ventura:        "78bbbcb4fbe4a8815f58feb6a76cde6a97b6a37ad8527ad151b108eb0dce5f2a"
    sha256 cellar: :any_skip_relocation, monterey:       "32b6db2051b432fd761e6d032a2041f3e784b8056179d3373494587a35df978b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "527e074294fa2e45975f5f51b144e75de2b3d2357c210210ff97bbce9a8d02fd"
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
