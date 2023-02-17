class Evtx < Formula
  desc "Windows XML Event Log parser"
  homepage "https://github.com/omerbenamram/evtx"
  url "https://github.com/omerbenamram/evtx/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "a42133deecbe47ade28e14ed55e4e87a2c9b5d9400867eacec8b32070a2cd95e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/omerbenamram/evtx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a6330604079125e15e6f71fc7ca1e1baf83db6b853eba13c38dbb0d87209de5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e7f961c5cd09f89b72d8efe0fec20598e8f6432b48cf4801e2533519efdad4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de3c53f67f3b94405574c0093d2658d2dd0318a13b4a0915f6639d5f3da61652"
    sha256 cellar: :any_skip_relocation, ventura:        "9bdc56a61ed281f0e59a56ac891afa3535d61697fd5321afef97e3054aeb72c9"
    sha256 cellar: :any_skip_relocation, monterey:       "2b1c84ddc575275d2f4b9d6b42997357d527256e0c0c647c127ee3ed98628fab"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ffad35e879637563bee699a77f2fbd06b7c77821f4e98db540b41a4d78df298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c70233d98863da032024b33993dd7f88fee68b8d39f75b518f3507bd20bd5804"
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
