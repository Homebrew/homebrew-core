class Mlc < Formula
  desc "Check for broken links in markup files"
  homepage "https://github.com/becheran/mlc"
  url "https://github.com/becheran/mlc/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "d9e31137952c96230876f690bf7fb236e67c13fa3cd98eb505dbd98ffe2ad2bb"
  license "MIT"
  head "https://github.com/becheran/mlc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b11420c64f09652972ac4beaf38c15943ffdcd418a2548df45b2cd3951ee2a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dfec3208f0d0c65da4169e24ec02c1a39d136bbd073648549dde6ddd62c191de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d5656545c43ca5cb1ecc2db3299daa3f6015bfe63c289e701c056250086e7e3"
    sha256 cellar: :any,                 arm64_linux:       "845d67958063517d80af01b5498fdf10495e368cb853d03be8df25a106564473"
    sha256 cellar: :any,                 x86_64_linux:      "5378f4d6f65781acd847c8a68495131412bbc7f6135727d6e29d73267f900742"
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
