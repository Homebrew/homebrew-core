class Mlc < Formula
  desc "Check for broken links in markup files"
  homepage "https://github.com/becheran/mlc"
  url "https://github.com/becheran/mlc/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "202d44b983f1046cb0cbb45250c2ec815f038f8a35a79e425b05168bab1a5823"
  license "MIT"
  head "https://github.com/becheran/mlc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ad24725817d686ebec7b4b2d4779d0f19869c1f8285720512888baaccdf5929e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "80a82ddd10ba7faf10e672e2e7f512c38e966758f00f3ca0a1aa1c7ea9c93da3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "02b8c027057921525641d5d18ef318eea53678f138f20c7780db8413aeb86572"
    sha256 cellar: :any,                 arm64_linux:       "68664b6f94e66f5e44c416802b1dd0b867d5313f693bfaec077588fbfdba6bbe"
    sha256 cellar: :any,                 x86_64_linux:      "98b8ab6939e6535d93b6600f51ec9568502d6e9a2068fd57153fa647bcb9270e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Explicitly set linker to avoid Cargo defaulting to
    # incorrect or outdated linker (e.g. x86_64-apple-darwin14-clang)
    ENV.append_to_rustflags "-C linker=#{ENV.cc}"

    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mlc --version")

    (testpath/"test.md").write <<~MARKDOWN
      This link is valid: [test2](test2.md)
    MARKDOWN

    (testpath/"test2.md").write <<~MARKDOWN
      This link is not valid: [test3](test3.md)
    MARKDOWN

    assert_match(/OK\s+1\nSkipped\s+0\nWarnings\s+0\nErrors\s+0/, shell_output("#{bin}/mlc #{testpath}/test.md"))
    assert_match(/OK\s+1\nSkipped\s+0\nWarnings\s+0\nErrors\s+1/, shell_output("#{bin}/mlc .", 1))
  end
end
