class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "c6f0a1970c78c06c183756c26bddd11b142a004ff623e4546dc98446f7888e58"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "742a060e252a041287f6303f3a2ce89987d97dca52a66fa47a0fabf92b772acb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "742a060e252a041287f6303f3a2ce89987d97dca52a66fa47a0fabf92b772acb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "742a060e252a041287f6303f3a2ce89987d97dca52a66fa47a0fabf92b772acb"
    sha256 cellar: :any_skip_relocation, sonoma:        "72d7ef5029612fb328c8e4638228d4db4654fbec9b021e799979e3f25e4ee564"
    sha256 cellar: :any_skip_relocation, ventura:       "72d7ef5029612fb328c8e4638228d4db4654fbec9b021e799979e3f25e4ee564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed0a44956ce7f35a83ae7669c89e563254ada2b23ad9872572dcb75813cfbab1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "Failed to execute - Failed to create backend", output
  end
end
