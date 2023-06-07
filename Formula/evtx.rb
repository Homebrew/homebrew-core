class Evtx < Formula
  desc "Windows XML Event Log parser"
  homepage "https://github.com/omerbenamram/evtx"
  url "https://github.com/omerbenamram/evtx/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "a42133deecbe47ade28e14ed55e4e87a2c9b5d9400867eacec8b32070a2cd95e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/omerbenamram/evtx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c89cce02eb42c8ffeff871f32f50bce01ca94d822dab012aa27cf138579665e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e750b8532e6e8c3b08ee0b20f373b1f5baeef338ecead535efd37f59e8a29b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be9205c5372de648dd450bf3c8a8517900a4f1a92cfaeaa1f83bdc126e4244f7"
    sha256 cellar: :any_skip_relocation, ventura:        "ddac9599c1e47f77ee5ae33494d613a2fdc2a96ac64afc29990c0429c640107d"
    sha256 cellar: :any_skip_relocation, monterey:       "8e624562b6931b531fb1911296f3d404376b1cf14a61b7bb7e768a6c5698d98d"
    sha256 cellar: :any_skip_relocation, big_sur:        "aae2a058428541d793bc5cbdd31b9c01b30d7add7f19e12532ae5158dbfe4366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14305e3adbec154630f7de1e926f3a27b36d7fa091b0ca9b11cf1a0d2e772a7f"
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
