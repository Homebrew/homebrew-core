class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://hebcal.github.io/"
  url "https://github.com/hebcal/hebcal/archive/refs/tags/v5.18.0.tar.gz"
  sha256 "0a7eb7b9922f5b42bd6776a3eb32bbf645458009c26a787c20011b96f6c33636"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d5ecbea88ec3057e1efe6e5f5400653b1520a3d3982411067a5c03b00790d79d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d5ecbea88ec3057e1efe6e5f5400653b1520a3d3982411067a5c03b00790d79d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d5ecbea88ec3057e1efe6e5f5400653b1520a3d3982411067a5c03b00790d79d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a0001d7da6f7a8431c2059ef8a9db5d820bfd27c0ba41dd6f4e118f6597945c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "997e9e20db2b6fbc02d4417973f9ca440901b71a34318f3ac52bf36c9d1bd4aa"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    # populate DEFAULT_CITY variable
    system "make", "dcity.go", "man"
    system "go", "build", *std_go_args
    man1.install "hebcal.1"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
