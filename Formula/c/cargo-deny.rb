class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.14.13.tar.gz"
  sha256 "00df786eba77f3be471b261dc2686be9d57f64bfb5693e47ddb3c3c7e633e1c3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c78b429d2d5675fc7cddfa772da1863d7552c95aaf4f64b5b850c8460d3d8e90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f58500a402e5791cc16fc973c72ab57519a91d6d0d503b4abcdb48763655dd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47576cbb32a26ce81001d089b4d34d2bfd53594eb21683f11ab4ba9df23c5b96"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a914e350798f34255b3cb9b9f81d0a3c29a6029b60db1a994a905ce58e3125d"
    sha256 cellar: :any_skip_relocation, ventura:        "8ad399b8d64fad3688e869585d9f2855b8b5489c6e0ac23b305c7f57af2000f6"
    sha256 cellar: :any_skip_relocation, monterey:       "b407f271e73f046c4070f47b7847b38462ca544f10109995d8a7bfa81e86ffb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b87af9c3691c664b8b7f722b25480aeec016889308c3532f314406c2659df6d1"
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
