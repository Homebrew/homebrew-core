class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "99fe3ad86f0c83214ce73b5450f47655056ee69549e843f7749f2ae4c9e4425b"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ead785d66eb4d0564c3f243a4b64f9d638bcac8d9945396f3995f257d6d47f49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20d54514d547793f9d196a8e0547841dac9fa45f70e7b5474fb6d11ad61e6985"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bc02d0e411ae5424953ae53b287796f56b95066fe09dc824e3f4f514c3cbe5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77e921302a74d5bb261dc3e957d61c1fcae50e0f9b4a1ae4e1fdf2198d7cf05a"
    sha256 cellar: :any,                 x86_64_linux:  "0e07ee0508fabab128dc31b9dd385f49d684ff35e4ed6adfd375d3927cd5b3c9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "failed to create backend", output
  end
end
