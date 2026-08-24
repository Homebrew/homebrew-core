class LeetcodeCli < Formula
  desc "May the code be with you"
  homepage "https://github.com/clearloop/leetcode-cli"
  url "https://github.com/clearloop/leetcode-cli/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "52bc5bac21dc52a0d498c8b817f9e04c7267ba9febb08d4ed0a158e91893d6cf"
  license "MIT"
  head "https://github.com/clearloop/leetcode-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3181907993e5b87ccaa625d9432561dc02c844ba1df3eec71a8ee1ead47b0cb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f2c4b7e80ba8bc455fc2fc4355081cfe5d8f8576e76d383d3c92d24708e3a44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "813ce29f2e10fb14eafc63afc0fa73eef63911b091bbe2becad1ee9aca7d2725"
    sha256 cellar: :any_skip_relocation, sonoma:        "03158a6ea9c503825788c6c236c35f2f24fe3a54db8d4b2ea53c8c29e9e4a94e"
    sha256 cellar: :any,                 arm64_linux:   "b7537396bc808fe67a01bdbb467e7be56c09b8a7af03aa8b3760a5e96d23dbf2"
    sha256 cellar: :any,                 x86_64_linux:  "6d81ad3d3200763b069fcfc2b452792eed482bb33669e046fabf58f5227ecc0a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  uses_from_macos "sqlite"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"leetcode", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/leetcode --version")
    assert_match "[INFO  leetcode_cli::config] Generate root dir", shell_output("#{bin}/leetcode list 2>&1")
  end
end
