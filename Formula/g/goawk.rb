class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "2df274d8680a9405646b0729b6465b8952f795f118358cf8a25fe1526cbd0909"
  license "MIT"
  head "https://github.com/benhoyt/goawk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7aa05da6706f6f37b6b6e39b5836857813c4076a7c58f91676d8ef4856032e4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aa05da6706f6f37b6b6e39b5836857813c4076a7c58f91676d8ef4856032e4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7aa05da6706f6f37b6b6e39b5836857813c4076a7c58f91676d8ef4856032e4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e8db0d21391319af239e1d699968d412d98b88432f515b5a305338d5a9347aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69823243b989010cec1a19abbd4ec23078b3fea8277d22e0c88308d7a97668e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0427800ae701c9b427ac9d7c492a2fa9dde61ed17716f2395e1a72515311e6d1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
