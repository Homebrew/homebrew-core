class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.14.22.tar.gz"
  sha256 "6661a22bcd0929a125c090d0386967d741aacadbf5e202627ca8437e01906147"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35454b7b2c01506e8317d58c68a6fed667b0ac6b25c2fd5437e4980339d9f4bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4359e992017bcd6b03edef67208b9e4437c77d144368fd11a41013147e56101"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cac6e3e7a67b3f3ccfacb0617555e81250950c1443e004b7fb9f69ccaa945df1"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2c5f7ea6d6c3c05d3661c87459f6cd4ed9a15ca6fcdb577f540616124e6d9ac"
    sha256 cellar: :any_skip_relocation, ventura:        "ca94c8e45aadec8c561f4bea427ffef367b8c93b33627055515182c98e0d6759"
    sha256 cellar: :any_skip_relocation, monterey:       "4d778ea8c8834af8633ee964f05518c457ac28b88646de9686a8f334e8d5a000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a40de2840af63b1162f987c6243453d986aeb23912174df278ca612e60a0091"
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
