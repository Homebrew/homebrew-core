class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "b578d050fd0be2ccd1e364cd3a3940e86970e652920c31299d97d1849d9d7450"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8506350927946f262d00c631bb15150454f133d46c739f47a23fbcb435bbd33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4902066b1a8081d124c7fee1a05ef27bb5c984011966117a6547266e8cc38673"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb823bdd37c50898abab6b97fba031ddf30cc04acbdc344d3426405e8fda05c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e66735b66dd72b618e10e677233fbce78ef91a80ecfcc29c1ee060d3b67c2fa1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f173b89ded7563601558a11bd58b9d428a7ba9354012c09524fecf6fdeabe47b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f431a137098445549637dd5e864690556a870b20fe833a31a48afd81424ae439"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "failed to create backend", output
  end
end
