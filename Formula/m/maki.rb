class Maki < Formula
  desc "Efficient AI coding agent extendable by neovim-like Lua plugins"
  homepage "https://maki.sh"
  url "https://github.com/tontinton/maki/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "6c4161c5e6e72668dd6141cae627bb59664fe8cc934325f1818cadfa4852c795"
  license "MIT"
  head "https://github.com/tontinton/maki.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "71e8103111daf3d62144c38fcf66551ccbbfdc8e9afc9350d00c6ec79b780a33"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5f1dadb86e8ce14c51084e369d179a155c1d89132740b8e6415e8aec8f1f4ea6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "defab1e2cea3ca4f7fa588925f63fdead8f16182f0c22162c9b7b49d9aee8e9f"
    sha256 cellar: :any,                 arm64_linux:       "f5e84a3d8ea0d4defe2b0f9ece68f3f1857e9ca57b34543f2be73fe5ff0b3d03"
    sha256 cellar: :any,                 x86_64_linux:      "3b9ff0a9df598999b0d81b2202e6ef39e51c9860915818d1062a072f94190c10"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/maki --version")

    (testpath/"test.rs").write <<~RUST
      fn greet(name: &str) -> String {
          format!("hi {name}")
      }
    RUST
    assert_match "greet(name: &str) -> String [1-3]", shell_output("#{bin}/maki index test.rs")
  end
end
