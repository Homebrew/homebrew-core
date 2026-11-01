class Evtx < Formula
  desc "Windows XML Event Log parser"
  homepage "https://github.com/omerbenamram/evtx"
  url "https://github.com/omerbenamram/evtx/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "0b62f517a580f6afe30e9c6ad543e0e9d2763e47fc5d724a508526aa49e8c840"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/omerbenamram/evtx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fbd6423e69d4e16125ecbe90717158b26116b866912eda15a96008281efb3463"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "57b865e3cd45b3102f4fa5ff7d5cdd389da2ab1a72d87ed843dd02eceffa45c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b229f72673d1c252dddf2ccb6acdab4e899fca350ffd39a02b131013fd922fa8"
    sha256 cellar: :any,                 arm64_linux:       "33e247e0dcda2cab82bfb16e1cac15920272f534e43fa8ba0b2ecae812abd0ef"
    sha256 cellar: :any,                 x86_64_linux:      "7029aff96652511e8fe52a415321e04a1800d39dc4c560dfdba435b1ad5cc998"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
