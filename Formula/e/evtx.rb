class Evtx < Formula
  desc "Windows XML Event Log parser"
  homepage "https://github.com/omerbenamram/evtx"
  url "https://github.com/omerbenamram/evtx/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "b1a8d6c2e176fc67d9c6431255847d657024ac4ec32c8752375e189171bcfa57"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/omerbenamram/evtx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14b66d509ebd7829d09268b6babc721bb40f43fb462dfa15576fe0677e8e61e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39270961c9b9c822158a48b3568b193cf0a9258f1aa4fb74786c1c49fee25160"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6183490db0fd4f8093b872b20ccb04621baaf6a1f69ba19042a4537e81413f3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "86485fc045f5223fb61430c7a5bcb64681b8f7536e68fbc3f7f7659488509faa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44bee646ed5a476aafb00c3c54b243a3b6abfd05544e2077e935457f96e12ad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4222f3e515023e356d554780af9067f84f3581a7b87bae63cc2a14dc216d1546"
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
