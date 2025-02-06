class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v3.9.1.tar.gz"
  sha256 "cac962e77605079612ac3b4447681b6866113b8dacb56c7014b3b3cea9545f33"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7eaf27836a578a3e30c24579da429b61c578c1ac143d559a4977fed3ddb6edbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9370106b70fa9234617cebe008b60b14ea99a81c9415dfae2e8e215a56be0fda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d77d2d7c5f5bcca3529c4945c812c88726d8e23288cdf383d16a1f37ba30fed"
    sha256 cellar: :any_skip_relocation, sonoma:        "427c1f0d63c320613442522302bc767f980f103818039a005d2ba7239d249888"
    sha256 cellar: :any_skip_relocation, ventura:       "286e7f5aef4b35cf3ef2e622bf49f039f1909cf357752c1256ed01c80df088b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12cac5870ee4397d6af2d354bd4e24e1768528e3caf3d51654a3113aa66a5b2b"
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
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

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
