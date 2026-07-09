class Evtx < Formula
  desc "Windows XML Event Log parser"
  homepage "https://github.com/omerbenamram/evtx"
  url "https://github.com/omerbenamram/evtx/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "d1d69b5e4daab47214eec816bb3ef3b4cdadf3921879b4c422210b8dda297cd3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/omerbenamram/evtx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14056c38ae410b13f9c0899db53ad1ce5c842b8702fd40fd69afa85385d19df9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca2554822e49c8a2f23b07654b451203a362b1f693466f28132f5090926b5cfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab567dacc770f023f3a8af124ce154b0fce80a92cdac70b89cdc7efc82be2142"
    sha256 cellar: :any_skip_relocation, sonoma:        "f50135e8d7f430ba1dd78e343708a0eef87de384f41c897bed49e756418ee551"
    sha256 cellar: :any,                 arm64_linux:   "5fe5fec81b8775de162690a4b75c10ef5669f36d7c6c364a334372b949a847ad"
    sha256 cellar: :any,                 x86_64_linux:  "7f55a0f0b432f1f5392abe5236c66826860375328e0d437003610343f90b82ca"
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
