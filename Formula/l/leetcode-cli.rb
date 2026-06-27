class LeetcodeCli < Formula
  desc "May the code be with you"
  homepage "https://github.com/clearloop/leetcode-cli"
  url "https://github.com/clearloop/leetcode-cli/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "9b5943a26b50031400f762dd3a86e12c4dd1254b51aa12d311a0e1c320cf3c89"
  license "MIT"
  head "https://github.com/clearloop/leetcode-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6401aa88a7189d79856dc2741c1986698a89e28fcc96a2ab01c7b0bcf3984bcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f30e017dadc6f7c9e98478c6ded678c890b9b3e0b9cdd58720fc865b7f0ecc55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26b6678ddd69cc2122183de81d12631f285f873cca2a7c33423b2c4e61dad7d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e86bd729e541afdc5b0fc3cfae4c152282ace6a5e52421091c932bc39dc1301f"
    sha256 cellar: :any,                 arm64_linux:   "1da452fa3a0ab69f51ace5e41b4dee9d635eefbda1843d60753742ad68657f0e"
    sha256 cellar: :any,                 x86_64_linux:  "11c9c8dd4c41d693aafab7900bff14cdd662dd580abd7bfc29be28aee94267e8"
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
