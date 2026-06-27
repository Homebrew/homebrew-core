class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "2c08afa0c33127809482136ff6d76d94960441b34f5b159258a945cbee09491a"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6116d92d02033c4b32e7e4b184fdc75f339e8dc6353075d6eb92be2637fe2d2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c075dd8a17a80a7265fd77d796d1f8e9b06d058aea472808890be7131ad63fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b626087aa2748604df9db8d9e153a3a7b634aceeb8549393400d28dfd7d30496"
    sha256 cellar: :any_skip_relocation, sonoma:        "5037e28099f7f734c7201c902f630062621e8d0a9f37d1746272445bf9afb595"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "353b2e6ebe280e67a639a331b0a12290f62e43a7f63b048d78687372f5fcf4f8"
    sha256 cellar: :any,                 x86_64_linux:  "bdd3430c44e221a7c3d07b60c5524f2893e82079c98b92e26b3d41b8997306b5"
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
