class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.14.18.tar.gz"
  sha256 "0a01ad3390dce30f5c8b8eb05145f10129acdd8858aee1d037e346687735b09b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78aa42c1e9fe359ca88707e1d9a526bb99fb83386d144893707e212e6afe3608"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e27ab281a38279c5e9da812fb6e40b5e4a4e7a7e8db6d3e35594bec5dc72a87c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "162e2179d7f63d90b16f6e4a0016c781abf8669f034dd3ee4cbf422ec1d222a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "caeb960ce173e49c752939b367abc38a46515fbb60f17376ada905bd33d37ff8"
    sha256 cellar: :any_skip_relocation, ventura:        "0ef0dcf702c813ae22d72fb15ba11db1d01af67fbb0a8f5598b0772666a2a825"
    sha256 cellar: :any_skip_relocation, monterey:       "cc983dec0ea0017bcee4d44ced12ff4ea037a222677d39ddfcc26e1bb68136f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d64fb3933b2d9202e30c1d1205ea0f779c187cd7f04b986f0c262f2b89abe8a5"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      output = shell_output("cargo deny check 2>&1", 4)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end
