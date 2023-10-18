class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "009c7ca9e3903ea7141d9979a1006ef0e3bf0d6e5e294c88d4ea76194422c3e0"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "feff5f6315ea4df528c36fe87be464af1e2e909558c838de8e6cbfdbcc1168f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acbf1068d144f75e59a8fce5261b0aaba79eaad458c025851b2d0236fe2fd8fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3932b2c882a0804cf408ed8817ecb4bc6e9a306a7a627b48991bf5df0ab66c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10e309cbb62f2ce114c18ccc3bf5484a97d63cfa4812dcad6c7665462fc6ecc5"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe52847eb8c451052921ae5daf00b8531ae50f3a55585f164b743b4bb579b12b"
    sha256 cellar: :any_skip_relocation, ventura:        "948906917e2602baa8f18fc1a0c2ba5ff66816cd5dca8e6355d372f58d938b79"
    sha256 cellar: :any_skip_relocation, monterey:       "75f896025c92e27bfc153e74d5b70965538c88d49820313c2cca0af69c0010b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7efba89490490c713e2340e33ff4020d15170bc19d165810092f9c97af76fccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65b866345eb27740122788c2d6ceebad3efd19a91eb2990c525bab8ba16588fc"
  end

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
        license = "MIT"
      EOS

      system bin/"bacon", "--init"
      assert_match "[jobs.check]", (crate/"bacon.toml").read
    end

    output = shell_output("#{bin}/bacon --version")
    assert_match version.to_s, output
  end
end
