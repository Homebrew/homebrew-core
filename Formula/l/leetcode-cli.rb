class LeetcodeCli < Formula
  desc "May the code be with you"
  homepage "https://github.com/clearloop/leetcode-cli"
  url "https://github.com/clearloop/leetcode-cli/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "9372258ecc592522edbfe9394a29091970616a7c629ffe1d953f9b73734b09c3"
  license "MIT"
  head "https://github.com/clearloop/leetcode-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a8ef1221559639a6fb18c6b6e786783327a4af8ea53b23bfaabf2dfaefe9e3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60053889d3d28e6efe609254773988d1aa56db188792ce0a9e6de88238e03116"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "377d5d3f9865f60d272e79ce2aa8e63b9c047ec47d20daa183a91907bb241a8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7a5f1edc33325631d109487800b77353ab5198fa8d85b29cf25061ea583e64a"
    sha256 cellar: :any,                 arm64_linux:   "0dde53d6c0d9d2f874d2329965433ca99f56e7fff138d296940f5a3430dc801e"
    sha256 cellar: :any,                 x86_64_linux:  "1c2ab430073b9b3aed478c85551b6277d1b9017acce839013f25af79000cee81"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "sqlite"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"leetcode", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/leetcode --version")
    assert_match "[INFO  leetcode_cli::config] Generate root dir", shell_output("#{bin}/leetcode list 2>&1")
  end
end
