class AttemptCli < Formula
  desc "CLI for retrying fallible commands"
  homepage "https://github.com/MaxBondABE/attempt"
  url "https://github.com/MaxBondABE/attempt/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "95c0d7873db135361f5de50e1add0aa472f543dd499aec3cd1fda678672c850a"
  license "Unlicense"
  head "https://github.com/MaxBondABE/attempt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a8881fa613c85f2f0c9a65950de36c1b684aafda39b6b3858f78c60d18a3e48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07e2e1e6833b054ef29933a6ed02b0f59a79ca42d76f4e8cf7bbbc7b070f1c45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "543b5a378075c437c6de8e8cb46fa0ce429e37f99aaf0edf0f57bfa24205206a"
    sha256 cellar: :any_skip_relocation, sonoma:        "33006a9c41e7804a56c6cba52cf4c05d665b1b0cd1c10546e408a4d898381bbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0864b36766d2d2ea8917cc9abeb7e0f8eb421e0c40d4ff2ccf3de1048107dab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ab9bd07ecd55a0d594b9d94a4a037f5425a277dbd99572dba81eeedf51c4095"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/attempt --version")

    output = shell_output("#{bin}/attempt fixed -a 1 -m 0s -- sh -c 'echo ok'")
    assert_match "ok", output
  end
end
