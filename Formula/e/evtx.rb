class Evtx < Formula
  desc "Windows XML Event Log parser"
  homepage "https://github.com/omerbenamram/evtx"
  url "https://github.com/omerbenamram/evtx/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "5330f3d811fb3aae468260d01f95103385c1ad7caca37ee282814c9e37956cd2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/omerbenamram/evtx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9a08326a9f0040402c643c74981ca3751d7c9756b9345b7fe1d1136b1b64d9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9befc7de4842db5c3b744c7e89b0f12cd71e628701d68aa1f6fab62279928f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85952b2482cb1295648bc41ad7d2590b5cd29eaa4f54ec94c1daba23aefad54d"
    sha256 cellar: :any_skip_relocation, sonoma:         "06e95d033e243eb16affbeb792ec4c3e3f45f50f4405ce02086db3c2f45d8c1c"
    sha256 cellar: :any_skip_relocation, ventura:        "2aa03c55d82c917765c0c090c4c8234b18a28a0dfbd80899fe82e57316765bea"
    sha256 cellar: :any_skip_relocation, monterey:       "5cf96ccbf1e4c88cef69a4ecb90c45c087b3dae8558facc129d28078500de570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60b07c39ea85e0220645fab752a97577460a1e4f2645cf482fe2c4ee9df0cbd3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "samples"
  end

  test do
    cp pkgshare/"samples/issue_201.evtx", testpath
    assert_match "Remote-ManagementShell-Unknown",
      shell_output("#{bin}/evtx_dump #{pkgshare}/samples/issue_201.evtx")

    assert_match "EVTX Parser #{version}", shell_output("#{bin}/evtx_dump --version")
  end
end
