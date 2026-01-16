class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v3.21.0.tar.gz"
  sha256 "4d258b57976f234547d01ad64e3609e675a5689c28107e74e75bfbede82bf20a"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f20eea4ac33022a5979c3b1a1264dff38c6f0fa6b82c94b477106fd032f49bfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1aff917fc6dcb14700d158f6762050b9b37681d86dd1a0c2f12a48e57171fcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d0f34d068394a18c3d683651e0aaeb5c9d73979bb01917e8b441a3dbe64c6db"
    sha256 cellar: :any_skip_relocation, sonoma:        "0aeb89ecb831573ffef666dd4e03c0385d71b7e3fc4cc59db858887c40484ecd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27ef0626b1831168f162d90d92cc3934d5ed3f7d2506892736b87811b3ec161b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a15bf9c710270c87281094c987da22e9b848e34420735ba66923739e13b64f2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~RUST
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      RUST
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
        license = "MIT"
      TOML

      system bin/"bacon", "--init"
      assert_match "[jobs.check]", (crate/"bacon.toml").read
    end

    output = shell_output("#{bin}/bacon --version")
    assert_match version.to_s, output
  end
end
