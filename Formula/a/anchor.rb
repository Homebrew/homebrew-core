class Anchor < Formula
  desc "Solana Program Framework"
  homepage "https://anchor-lang.com"
  url "https://github.com/solana-foundation/anchor/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "e45fec416a1a13dd20112f3f52855b91180448b3298808d7e42c6cd57ad4ae48"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "5c42d288ffcb5ce0e5de2a3e623ace63a6401fefb6d9d0549ea27a6e89ec9f45"
    sha256 cellar: :any,                 arm64_sequoia: "999f1fb89d761dd51989f1f97fd5a6508fdfc03f2e39aba8e61bee328635f016"
    sha256 cellar: :any,                 arm64_sonoma:  "3805433758f3398f5490ff2f412063a66ca278c70bd5ee7d7632b32dd278a031"
    sha256 cellar: :any,                 sonoma:        "f01ce12914e4c50c25a5584320ae4b10a7d5b7522268f81ac248543a5431722d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5caca9952baaa452ab5c21538cf1e388887df6af5f0272872d43b0745347ae5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0f0b6dfb3a31ade18458dc13ec92ec5c91a553a1c5785f4c8432e9e153491a5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "node" => :test
  depends_on "yarn" => :test
  depends_on "openssl@3"

  on_linux do
    depends_on "systemd" # for `libudev`
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"anchor", "completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match "anchor-cli #{version}", shell_output("#{bin}/anchor --version")
    system bin/"anchor", "init", "test_project"
    assert_path_exists testpath/"test_project/Cargo.toml"
    assert_path_exists testpath/"test_project/Anchor.toml"
  end
end
