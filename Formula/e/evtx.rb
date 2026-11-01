class Evtx < Formula
  desc "Windows XML Event Log parser"
  homepage "https://github.com/omerbenamram/evtx"
  url "https://github.com/omerbenamram/evtx/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "0b62f517a580f6afe30e9c6ad543e0e9d2763e47fc5d724a508526aa49e8c840"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/omerbenamram/evtx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e710e1c9588c1292ce78b81bfb8718f97111b9a0e75111887e636a0d32f49a9b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d3e9ffed5202f53fbb060bdd979bde496cb3815afa77d51d13209646ed150d17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "59c3a236c4cf87bf076fdfa262355bb02dd8cba3df0671d461b51dedb0bd783f"
    sha256 cellar: :any,                 arm64_linux:       "5f267b2140e411665a048f6fa4208e62ad822c4eee7f1add8bf72bb0232b174c"
    sha256 cellar: :any,                 x86_64_linux:      "69834933acb34eec9f6e1b87c9e67c695e9e10672df28f5e2ce468c644f26856"
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
