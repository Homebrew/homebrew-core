class Gittype < Formula
  desc "CLI code-typing game that turns your source code into typing challenges"
  homepage "https://github.com/unhappychoice/gittype"
  url "https://github.com/unhappychoice/gittype/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "2efb51de5b8e00a4bc0086a3811e473f5934ca08750a32bcc39b19dfdeff68e7"
  license "MIT"
  head "https://github.com/unhappychoice/gittype.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7e88a8c36d46209b656fb61588d0983c20feb4262bbea466cd2d08a6318cf8c9"
    sha256 cellar: :any,                 arm64_sequoia: "15274a13d274d23e4c86439929d82909713e08ad8bb60453a46ccd9d8f14b527"
    sha256 cellar: :any,                 arm64_sonoma:  "b9bab3fa379260d3cdafed146f2ba4bac9f832326bfdaf9b845419f6d5195b8c"
    sha256 cellar: :any,                 sonoma:        "c41ef08d2cce1e3b3c81cf1558b75c7f7b29f3c0c54634c8a73a36fd135c284b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a74f9dd2de4c3e15286faf7f0b00a13ff73320cb335c07969506e8bb37dfcc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f92a14e1f59e49cda6a3d6e32d0d08abe6e427f62792c9a8ebacea3a0a8a5e9f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gittype --version")

    %w[history stats export].each do |cmd|
      output = shell_output("#{bin}/gittype #{cmd} 2>&1", 1)
      assert_match "command is not yet implemented", output
    end

    output = shell_output("#{bin}/gittype repo list 2>&1", 1)
    assert_match "Error: Terminal error: Not running in a terminal environment", output
  end
end
