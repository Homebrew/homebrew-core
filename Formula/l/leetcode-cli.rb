class LeetcodeCli < Formula
  desc "May the code be with you"
  homepage "https://github.com/clearloop/leetcode-cli"
  url "https://github.com/clearloop/leetcode-cli/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "326759d8bb413ae95ee358219014060802d0aa2df6f3c357e1e97814fa956dc6"
  license "MIT"
  head "https://github.com/clearloop/leetcode-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "38449111d697d39dc157659999f811f253b0ab3cf0c2683cbedb065f9896012c"
    sha256 cellar: :any,                 arm64_sequoia: "e8b57f789f903c6aab456c1b25841ca5ebf372e6640585e64fedef18bf35c605"
    sha256 cellar: :any,                 arm64_sonoma:  "46f55bc717a107df9f141f27e1f550038e775da606ff1b6a1feb9dc070ddd8ff"
    sha256 cellar: :any,                 sonoma:        "8a28a462ac693e6ee302aa43e04e7fefd22c01b68f843b23c421e9d147b70f8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c588d4c546eeca1c9f9eadfc237ab18d7903003bb6369d5007ccdbde3cea6083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7cce9674f796e3fb4c2a52d65e87d13ebb6d7159457d5705d171b3cac35dd69"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "sqlite"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"leetcode", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/leetcode --version")
    assert_match "[INFO  leetcode_cli::config] Generate root dir", shell_output("#{bin}/leetcode list 2>&1", 101)
  end
end
