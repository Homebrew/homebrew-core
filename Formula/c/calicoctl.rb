class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.27.0",
      revision: "711528eeb00fd90dde38e87ecee7d1c155cab0e6"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f35e23234b6684d5c950696d7b05bea9bb8b7445f25420342444e5bdbcd12f1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8730f128e1b2a69c12d915ff0a8f5d095ed672aab7b9a338d00b8cae0938ec87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06fd03b8da327e80f5f589e5c367b0e8435021d3f5d5d81243bfbb34270e5816"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a409c72d0721c21dc02f84aacc9e2711dd881e94d3cd6f9a52461edfda18255"
    sha256 cellar: :any_skip_relocation, ventura:        "4827a47ac46ca906ee140f8ef555a92b78812e02661c9821de20082c887b615f"
    sha256 cellar: :any_skip_relocation, monterey:       "c44fa0560d481a01fa6cca1670d1471e521d27059e45e5628b6993b8d67deed3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "657c0d92c4805cc96eb8f2c611cd4b0827c819d14474cc4266d57e632da14c89"
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calico/calicoctl/calicoctl/commands"
    ldflags = "-X #{commands}.VERSION=#{version} " \
              "-X #{commands}.GIT_REVISION=#{Utils.git_short_head} " \
              "-s -w"
    system "go", "build", *std_go_args(ldflags: ldflags), "calicoctl/calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version")

    assert_match "invalid configuration: no configuration has been provided",
      shell_output("#{bin}/calicoctl datastore migrate lock 2>&1", 1)
  end
end
