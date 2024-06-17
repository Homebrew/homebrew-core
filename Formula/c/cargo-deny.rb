class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.14.24.tar.gz"
  sha256 "e5cde78e62af26676c75875abe86119437b8e20537d7062111c423d05a1fc3d0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c039bda8ba95e0ae05b0aaab0af16b86198ecce12cb7abb158478b77f571ec8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c53b600a47b0cf1d3d89992dcf6ac264949fab24675a2461f2d8f910d9855e79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "187aaef5d4865d646b3a33b02b891e3864de75f825dce2f72458730fbf775209"
    sha256 cellar: :any_skip_relocation, sonoma:         "a47d018adf224f5304a4da97551c065fd5516bf8f569b573b705b56a61249024"
    sha256 cellar: :any_skip_relocation, ventura:        "a60bdbcc251d57ca0164b95d7b474461a9edee25bb813c530ece37de0a2e66d0"
    sha256 cellar: :any_skip_relocation, monterey:       "12a9f3a7474433dbf351362d0160a928f85fa054133199b0ab3e887f15f2b88b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f652d8f35e2d5436e522e93dfdd2ab89d704099823eb4ec6aa7eccb08cf06df"
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
