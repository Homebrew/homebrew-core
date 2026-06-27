class Gittype < Formula
  desc "CLI code-typing game that turns your source code into typing challenges"
  homepage "https://github.com/unhappychoice/gittype"
  url "https://github.com/unhappychoice/gittype/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "aa5f5ff1240946352456d2c56f37373ad9f5f480f58f77cee09a7a56c9a8d44b"
  license "MIT"
  head "https://github.com/unhappychoice/gittype.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "55d74902bb683fcd995a02d4b32540b7b8a9f8c6b899f545fec5d0d786966f34"
    sha256 cellar: :any,                 arm64_sequoia: "2def9f375411ffa25cbc2f78f6a5922540736a4207b79af270618089c1015b0d"
    sha256 cellar: :any,                 arm64_sonoma:  "41507c0373c0b762f058069194a87ba55f4127c7459a563f61f88d5e3acd2fb5"
    sha256 cellar: :any,                 sonoma:        "46756614b1d7788eb8125f6aaba0273dff6e2b8308450fa45e78f738f0ad1337"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "083b8074b0296a7509bffd8ddced72123af65c1064e4be431eb333b73d45c577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bcdcbf4dc81785651d4919c7c4f33ebe732ecf8e07e0e699e04357f96bfa963"
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
