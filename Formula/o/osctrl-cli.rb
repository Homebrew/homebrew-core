class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "4f62d6ecd3a0e8b76b1c3d555458f344c617bed000702e67a3e549b83c6d6633"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f5cbb519d2ae714bd27178534d93dfd0a925f76313d459119c951f78ad4d627"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2e024967c79071ba28b017d1dcd91ae3ff6db1f0fb4d806df2a1c2588a8395f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0127c3e707d2945c79ec48e5f37a56d2105d8f787211818b1b0be3b3c91642cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "20604e7ad0d572203dbbdb807a3b528a50c5047d39cc0631d98db4496daf51f2"
    sha256 cellar: :any_skip_relocation, ventura:        "182546b3b8796f90a65aa7b5006ed41954d96297386c4291178090cbd589c3ff"
    sha256 cellar: :any_skip_relocation, monterey:       "217b572b7a32684eb013f5f694311af61411b6e2edbe688c3bb5d42685466741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0642e218e1a753cf7c90b8ad087755fb3862b0679d8be41c806cb3c2cb7538f3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "failed to initialize database", output
  end
end
