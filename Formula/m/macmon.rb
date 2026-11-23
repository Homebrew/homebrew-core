class Macmon < Formula
  desc "Sudoless performance monitoring for Apple Silicon processors"
  homepage "https://github.com/vladkens/macmon"
  url "https://github.com/vladkens/macmon/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "66c2446bb755132cbd1e9af018c1b351ba5e79c9dde4092586cd5c69852abaac"
  license "MIT"
  head "https://github.com/vladkens/macmon.git", branch: "main"

  bottle do
    manifest_sha256 "200cad0c26653deaa75c56e0514d6c420b58c535d2ed2aa927046db1657ffa1e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8a9e810af97e0798da86082f592cf46ddfc519d9fd392ad33ec80c3cf2add1c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1a393caf3674c75e5282940c8eb294314bb21f3b3e386395cb575015bc384588"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "781f0868f796fde774f64341bf69a9e3b414b2ba910195527bdfe4df0bec5e17"
  end

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on :macos

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macmon --version")
    assert_match "hw.nperflevels", shell_output("#{bin}/macmon debug 2>&1")
  end
end
